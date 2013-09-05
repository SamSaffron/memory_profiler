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

      # attempt to work around lazy sweep, need a cleaner way
      GC.start while new_count = decreased_count(new_count)

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


      results.allocated_by_file = self.class.top_n(allocated) do |result|
        result[1].file
      end

      results.retained_by_file = self.class.top_n(retained) do |result|
        result[1].file
      end

      results

    end

    def self.top_n(data, max = 10)

      sorted =
        if block_given?
          data.map { |row|
            yield(row)
          }
        else
          data.dup
        end

      sorted.sort!

      found = []

      last = sorted[0]
      count = 0
      lowest_count = 0

      sorted << nil

      sorted.each do |row|
        unless row == last
          if count > lowest_count
            found << {data: last, count: count}
          end

          if found.length > max
            found.sort!{|x,y| x[:count] <=> y[:count] }
            found.delete_at(0)
            lowest_count = found[0][:count]
          end

          count = 0
          last = row
        end

        count += 1 unless row.nil?
      end

      found.reverse
    end

    def decreased_count(old)
      count = count_objects
      if !old || count < old
        count
      else
        nil
      end
    end

    def count_objects
      i = 0
      ObjectSpace.each_object do |obj|
        i += 1
      end
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
