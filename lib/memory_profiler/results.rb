# frozen_string_literal: true

module MemoryProfiler
  class Results
    UNIT_PREFIXES = {
      0 => 'B',
      3 => 'kB',
      6 => 'MB',
      9 => 'GB',
      12 => 'TB',
      15 => 'PB',
      18 => 'EB',
      21 => 'ZB',
      24 => 'YB'
    }.freeze

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

    def scale_bytes(bytes)
      return "0 B" if bytes.zero?

      scale = Math.log10(bytes).div(3) * 3
      scale = 24 if scale > 24
      "#{(bytes / 10.0**scale).round(2)} #{UNIT_PREFIXES[scale]}"
    end

    def string_report(data, top)
      grouped_strings = data.values.
        keep_if { |stat| stat.string_value }.
        group_by { |stat| stat.string_value.object_id }.
        values

      if grouped_strings.size > top
        cutoff = grouped_strings.sort_by!(&:size)[-top].size
        grouped_strings.keep_if { |list| list.size >= cutoff }
      end

      grouped_strings.
        sort! { |a, b| a.size == b.size ? a[0].string_value <=> b[0].string_value : b.size <=> a.size }.
        first(top).
        # Return array of [string, [[location, count], [location, count], ...]
        map! { |list| [list[0].string_value,
                       list.group_by { |stat| stat.location }.
                            map { |location, stat_list| [location, stat_list.size] }.
                            sort_by!(&:last).reverse!
                      ]
        }
    end

    # Output the results of the report
    # @param [Hash] options the options for output
    # @option opts [String] :to_file a path to your log file
    # @option opts [Boolean] :color_output a flag for whether to colorize output
    # @option opts [Integer] :retained_strings how many retained strings to print
    # @option opts [Integer] :allocated_strings how many allocated strings to print
    # @option opts [Boolean] :detailed_report should report include detailed information
    # @option opts [Boolean] :scale_bytes calculates unit prefixes for the numbers of bytes
    def pretty_print(io = $stdout, **options)
      # Handle the special case that Ruby PrettyPrint expects `pretty_print`
      # to be a customized pretty printing function for a class
      return io.pp_object(self) if defined?(PP) && io.is_a?(PP)

      io = File.open(options[:to_file], "w") if options[:to_file]

      color_output = options.fetch(:color_output) { io.respond_to?(:isatty) && io.isatty }
      @colorize = color_output ? Polychrome.new : Monochrome.new

      if options[:scale_bytes]
        total_allocated_output = scale_bytes(total_allocated_memsize)
        total_retained_output = scale_bytes(total_retained_memsize)
      else
        total_allocated_output = "#{total_allocated_memsize} bytes"
        total_retained_output = "#{total_retained_memsize} bytes"
      end

      io.puts "Total allocated: #{total_allocated_output} (#{total_allocated} objects)"
      io.puts "Total retained:  #{total_retained_output} (#{total_retained} objects)"

      if options[:detailed_report] != false
        io.puts
        ["allocated", "retained"]
            .product(["memory", "objects"])
            .product(["gem", "file", "location", "class"])
            .each do |(type, metric), name|
              scale_data = metric == "memory" && options[:scale_bytes]
              dump "#{type} #{metric} by #{name}", self.send("#{type}_#{metric}_by_#{name}"), io, scale_data
            end
      end

      io.puts
      dump_strings(io, "Allocated", strings_allocated, limit: options[:allocated_strings])
      io.puts
      dump_strings(io, "Retained", strings_retained, limit: options[:retained_strings])

      io.close if io.is_a? File
    end

    private

    def dump_strings(io, title, strings, limit: nil)
      return unless strings

      if limit
        return if limit == 0
        strings = strings[0...limit]
      end

      io.puts "#{title} String Report"
      io.puts @colorize.line("-----------------------------------")
      strings.each do |string, stats|
        io.puts "#{stats.reduce(0) { |a, b| a + b[1] }.to_s.rjust(10)}  #{@colorize.string((string.inspect))}"
        stats.sort_by { |x, y| [-y, x] }.each do |location, count|
          io.puts "#{@colorize.path(count.to_s.rjust(10))}  #{location}"
        end
        io.puts
      end
      nil
    end

    def dump(description, data, io, scale_data)
      io.puts description
      io.puts @colorize.line("-----------------------------------")
      if data && !data.empty?
        data.each do |item|
          data_string = scale_data ? scale_bytes(item[:count]) : item[:count].to_s
          io.puts "#{data_string.rjust(10)}  #{item[:data]}"
        end
      else
        io.puts "NO DATA"
      end
      io.puts
    end

  end

end


