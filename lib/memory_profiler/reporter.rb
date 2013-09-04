require 'objspace'
module MemoryProfiler
  class Reporter

    Stat = Struct.new(:class_name, :file, :line, :class_path, :method_id, :memsize)

    def self.report(&block)
      report = self.new
      report.run(&block)
    end

    def run
      allocated = nil

      GC.start
      GC.disable

      ObjectSpace.trace_object_allocations do
        generation = GC.count

        yield

        allocated = object_list(generation)

      end

      GC.enable

      # This seems to be required, first GC skips some objects
      GC.start
      GC.start

      retained = {}
      ObjectSpace.each_object do |obj|
        begin
          found = allocated[obj.__id__]
          retained[obj.__id__] = found if found
        rescue
          # __id__ is not defined, skip it
        end
      end

      results = Results.new
      results.total_allocated = allocated.count
      results.total_retained = retained.count

      results

    end

    def object_list(generation)
      results = {}
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

              memsize = ObjectSpace.memsize_of(obj)
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
