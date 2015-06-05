require 'objspace'
module MemoryProfiler
  # Reporter is the top level api used for generating memory reports
  #
  # @example Measure object allocation in a block
  #
  #   report = Reporter.report(top: 50) do
  #     5.times { "foo" }
  #   end
  class Reporter
    attr_reader :top, :trace

    def initialize(opts = {})
      @top          = opts[:top] || 50
      @trace        = opts[:trace]
      @ignore_files = opts[:ignore_files]
      @allow_files = Array(opts[:allow_files])
    end

    # Helper for generating new reporter and running against block
    def self.report(opts={}, &block)
      self.new(opts).run(&block)
    end

    # Collects object allocation and memory of ruby code inside of passed block.
    #
    # @param [Hash] opts the options to create a message with.
    # @option opts [Fixnum] :top max number of entries to output in report
    # @option opts [Array <Class>] :trace an array of classes you explicitly want to trace
    # @return [MemoryProfiler::Results]
    def run(&block)

      allocated, rvalue_size = nil

      rvalue_size = GC::INTERNAL_CONSTANTS[:RVALUE_SIZE]
      Helpers.full_gc
      GC.disable

      ObjectSpace.trace_object_allocations do
        generation = GC.count
        block.call
        allocated = object_list(generation, rvalue_size)
      end

      results = Results.new
      results.strings_allocated = results.string_report(allocated, top)

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

      results.register_results(allocated, retained, top)
      results
    end

    def trace_all?
      !trace
    end

    def ignore_file?(file)
      return true if file == __FILE__
      @ignore_files && @ignore_files =~ file
    end

    def allow_file?(file)
      return true if @allow_files.empty?
      !/#{@allow_files.join('|')}/.match(file).to_s.empty?
    end

    # Iterates through objects in memory of a given generation.
    # Stores results along with meta data of objects collected.
    def object_list(generation, rvalue_size)

      results = StatHash.new
      objs = []

      ObjectSpace.each_object do |obj|
        next unless generation == ObjectSpace.allocation_generation(obj)
        begin
          if trace_all? || trace.include?(obj.class)
            objs << obj
          end
        rescue
          # may not respond to class so skip
        end
      end

      objs.each do |obj|
        file = ObjectSpace.allocation_sourcefile(obj)
        next if !allow_file?(file) || ignore_file?(file)

        line       = ObjectSpace.allocation_sourceline(obj)
        class_path = ObjectSpace.allocation_class_path(obj)
        method_id  = ObjectSpace.allocation_method_id(obj)

        class_name = obj.class.name rescue "BasicObject"
        begin
          object_id = obj.__id__

          memsize = ObjectSpace.memsize_of(obj)
          memsize += rvalue_size if RUBY_VERSION < '2.2'.freeze
          # compensate for API bug
          memsize = rvalue_size if memsize > 100_000_000_000
          results[object_id] = Stat.new(class_name, file, line, class_path, method_id, memsize)
        rescue
          # __id__ is not defined, give up
        end
      end

      results
    end
  end
end
