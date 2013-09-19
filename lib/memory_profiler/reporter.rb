require 'objspace'
module MemoryProfiler
  class Reporter

    def self.report(top=50, &block)
      report = self.new
      report.run(top,&block)
    end

    def run(top=50,&block)
      allocated, rvalue_size = nil

      # calcualte RVALUE
      GC::Profiler.enable
      Helpers.full_gc
      begin
        data = GC::Profiler.raw_data[0]
        # so hacky, but no other way
        rvalue_size = data[:HEAP_TOTAL_SIZE] / data[:HEAP_TOTAL_OBJECTS]
        GC::Profiler.disable
      end
      GC.disable

      ObjectSpace.trace_object_allocations do
        generation = GC.count
        block.call
        allocated = object_list(generation, rvalue_size)
      end

      results = Results.new
      results.strings_allocated = results.string_report(allocated,top)

      GC.enable

      Helpers.full_gc

      retained = StatHash.new
      ObjectSpace.each_object do |obj|
        begin
          found = allocated[obj.__id__]
          retained[obj.__id__] = found if found
        rescue
          # __id__ is not defined on BasicObject, skip it
          # we can probably trasplant the object_id at this point, 
          # but it is quite rare
        end
      end

      results.register_results(allocated,retained,top)
      results

    end

    def object_list(generation, rvalue_size)
      results = StatHash.new
      objs = []

      ObjectSpace.each_object do |obj|
        objs << obj
      end

      objs.each do |obj|
        if generation == ObjectSpace.allocation_generation(obj)
          file = ObjectSpace.allocation_sourcefile(obj)
          unless file == __FILE__
            line = ObjectSpace.allocation_sourceline(obj)
            class_path = ObjectSpace.allocation_class_path(obj)
            method_id = ObjectSpace.allocation_method_id(obj)

            class_name = obj.class.name rescue "BasicObject"
            begin
              object_id = obj.__id__

              memsize = ObjectSpace.memsize_of(obj) + rvalue_size
              # compensate for API bug
              memsize = rvalue_size if memsize > 100_000_000_000
              results[object_id] = Stat.new(class_name, file, line, class_path, method_id, memsize)
            rescue
              # __id__ is not defined, give up
            end
          end
        end
      end

      results
    end
  end
end
