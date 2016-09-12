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
        found = allocated[obj.__id__]
        retained[obj.__id__] = found if found
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

      rvalue_size = GC::INTERNAL_CONSTANTS[:RVALUE_SIZE]
      rvalue_size_adjustment = RUBY_VERSION < '2.2' ? rvalue_size : 0
      helper = Helpers.new

      result = StatHash.new.compare_by_identity

      ObjectSpace.each_object do |obj|
        next unless ObjectSpace.allocation_generation(obj) == generation

        file = ObjectSpace.allocation_sourcefile(obj) || "(no name)".freeze
        next if @ignore_files && @ignore_files =~ file
        next if @allow_files && !(@allow_files =~ file)

        klass = obj.class rescue nil
        unless Class === klass
          # attempt to determine the true Class when .class returns something other than a Class
          klass = Kernel.instance_method(:class).bind(obj).call
        end
        next if @trace && !trace.include?(klass)

        begin
          line       = ObjectSpace.allocation_sourceline(obj)
          location   = helper.lookup_location(file, line)
          class_name = helper.lookup_class_name(klass)
          gem        = helper.guess_gem(file)

          string     = '' << obj  if klass == String

          memsize = ObjectSpace.memsize_of(obj) + rvalue_size_adjustment
          # compensate for API bug
          memsize = rvalue_size if memsize > 100_000_000_000
          result[obj.__id__] = MemoryProfiler::Stat.new(class_name, gem, file, location, memsize, string)
        rescue
          # give up if any any error occurs inspecting the object
        end
      end

      result
    end
  end
end
