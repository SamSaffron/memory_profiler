module MemoryProfiler
  class Results

    def self.register_type(name, stat_attribute)
      @@lookups ||= []
      @@lookups << [name, stat_attribute]

      ["allocated", "retained"].product(["objects", "memory"]).each do |type, metric|
        attr_accessor "#{type}_#{metric}_by_#{name}"
      end
    end

    register_type 'gem', :gem
    register_type 'file', :file
    register_type 'location', :location
    register_type 'class', :class_name

    attr_accessor :strings_retained, :strings_allocated
    attr_accessor :total_retained, :total_allocated
    attr_accessor :total_retained_memsize, :total_allocated_memsize

    def register_results(allocated, retained, top)

      @@lookups.each do |name, stat_attribute|

        memsize_results, count_results = allocated.top_n(top, stat_attribute)

        self.send("allocated_memory_by_#{name}=", memsize_results)
        self.send("allocated_objects_by_#{name}=", count_results)

        memsize_results, count_results = retained.top_n(top, stat_attribute)

        self.send("retained_memory_by_#{name}=", memsize_results)
        self.send("retained_objects_by_#{name}=", count_results)
      end


      self.strings_allocated = string_report(allocated, top)
      self.strings_retained = string_report(retained, top)

      self.total_allocated = allocated.size
      self.total_allocated_memsize = allocated.values.map!(&:memsize).inject(0, :+)
      self.total_retained = retained.size
      self.total_retained_memsize = retained.values.map!(&:memsize).inject(0, :+)

      self
    end

    def string_report(data, top)
      data.values
          .keep_if { |stat| stat.string_value }
          .map! { |stat| [stat.string_value, stat.location] }
          .group_by { |string, _location| string }
          .sort_by {|string, list| [-list.size, string] }
          .first(top)
          .map { |string, list| [string, list.group_by { |_string, location| location }
                                             .map { |location, locations| [location, locations.size] }
                                ]
          }
    end

    # Output the results of the report
    # @param [Hash] options the options for output
    # @option opts [String] :to_file a path to your log file
    # @option opts [Boolean] :color_output a flag for whether to colorize output
    def pretty_print(io = $stdout, **options)
      # Handle the special case that Ruby PrettyPrint expects `pretty_print`
      # to be a customized pretty printing function for a class
      return io.pp_object(self) if defined?(PP) && io.is_a?(PP)

      io = File.open(options[:to_file], "w") if options[:to_file]

      color_output = options.fetch(:color_output) { io.respond_to?(:isatty) && io.isatty }
      @colorize = color_output ? Polychrome.new : Monochrome.new

      io.puts "Total allocated: #{total_allocated_memsize} bytes (#{total_allocated} objects)"
      io.puts "Total retained:  #{total_retained_memsize} bytes (#{total_retained} objects)"

      io.puts
      ["allocated", "retained"]
          .product(["memory", "objects"])
          .product(["gem", "file", "location", "class"])
          .each do |(type, metric), name|
            dump "#{type} #{metric} by #{name}", self.send("#{type}_#{metric}_by_#{name}"), io
          end

      io.puts
      dump_strings(io, "Allocated", strings_allocated)
      io.puts
      dump_strings(io, "Retained", strings_retained)

      io.close if io.is_a? File
    end

    private

    def dump_strings(io, title, strings)
      return unless strings
      io.puts "#{title} String Report"
      io.puts @colorize.line("-----------------------------------")
      strings.each do |string, stats|
        io.puts "#{stats.reduce(0) { |a, b| a + b[1] }.to_s.rjust(10)}  #{@colorize.string((string[0..200].inspect))}"
        stats.sort_by { |x, y| [-y, x] }.each do |location, count|
          io.puts "#{@colorize.path(count.to_s.rjust(10))}  #{location}"
        end
        io.puts
      end
      nil
    end

    def dump(description, data, io)
      io.puts description
      io.puts @colorize.line("-----------------------------------")
      if data && !data.empty?
        data.each do |item|
          io.puts "#{item[:count].to_s.rjust(10)}  #{item[:data]}"
        end
      else
        io.puts "NO DATA"
      end
      io.puts
    end

  end

end


