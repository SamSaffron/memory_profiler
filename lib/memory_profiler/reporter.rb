require 'objspace'
module MemoryProfiler
  # Reporter is the top level API used for generating memory reports.
  #
  # @example Measure object allocation in a block
  #   report = Reporter.report(top: 50) do
  #     5.times { "foo" }
  #   end
  class Reporter
    attr_reader :top, :trace

    def initialize(opts = {})
      @top          = opts[:top] || 50
      @trace        = opts[:trace] && Array(opts[:trace])
      @ignore_files = opts[:ignore_files] && Regexp.new(opts[:ignore_files])
      @allow_files  = opts[:allow_files] && /#{Array(opts[:allow_files]).join('|')}/
    end

    # Helper for generating new reporter and running against block.
    # @param [Hash] opts the options to create a report with
    # @option opts :top max number of entries to output
    # @option opts :trace a class or an array of classes you explicitly want to trace
    # @option opts :ignore_files a regular expression used to exclude certain files from tracing
    # @option opts :allow_files a string or array of strings to selectively include in tracing
    # @return [MemoryProfiler::Results]
    def self.report(opts={}, &block)
      self.new(opts).run(&block)
    end

    # Collects object allocation and memory of ruby code inside of passed block.
    def run(&block)

      GC.start
      GC.disable

      generation = GC.count
      ObjectSpace.trace_object_allocations do
        block.call
      end
      allocated = object_list(generation)
      retained = StatHash.new.compare_by_identity

      GC.enable
      GC.start

      # Caution: Do not allocate any new Objects between the call to GC.start and the completion of the retained
      #          lookups. It is likely that a new Object would reuse an object_id from a GC'd object.

      ObjectSpace.each_object do |obj|
        next unless ObjectSpace.allocation_generation(obj) == generation
        begin
          found = allocated[obj.__id__]
          retained[obj.__id__] = found if found
        rescue
          # __id__ is not defined on BasicObject, skip it
          # we can probably transplant the object_id at this point,
          # but it is quite rare
        end
      end
      ObjectSpace.trace_object_allocations_clear

      results = Results.new
      results.register_results(allocated, retained, top)
      results
    end

    private

    # Iterates through objects in memory of a given generation.
    # Stores results along with meta data of objects collected.
    def object_list(generation)

      objs = []

      ObjectSpace.each_object do |obj|
        next unless ObjectSpace.allocation_generation(obj) == generation
        begin
          if !trace || trace.include?(obj.class)
            objs << obj
          end
        rescue
          # may not respond to class so skip
        end
      end

      rvalue_size = GC::INTERNAL_CONSTANTS[:RVALUE_SIZE]
      rvalue_size_adjustment = RUBY_VERSION < '2.2' ? rvalue_size : 0
      helper = Helpers.new

      result = StatHash.new.compare_by_identity

      objs.each do |obj|
        file = ObjectSpace.allocation_sourcefile(obj) || "(no name)".freeze
        next if @ignore_files && @ignore_files =~ file
        next if @allow_files && !(@allow_files =~ file)

        line       = ObjectSpace.allocation_sourceline(obj)
        location   = helper.lookup_location(file, line)
        klass      = obj.class
        class_name = helper.lookup_class_name(klass)
        gem        = helper.guess_gem(file)
        string     = '' << obj  if klass == String

        begin
          object_id = obj.__id__

          memsize = ObjectSpace.memsize_of(obj) + rvalue_size_adjustment
          # compensate for API bug
          memsize = rvalue_size if memsize > 100_000_000_000
          result[object_id] = MemoryProfiler::Stat.new(class_name, gem, file, location, memsize, string)
        rescue
          # __id__ is not defined, give up
        end
      end

      # Although `objs` will go out of scope, clear the array so objects can definitely be GCd
      objs.clear

      result
    end
  end
end
