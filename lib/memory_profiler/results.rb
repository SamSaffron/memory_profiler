module MemoryProfiler
  class Results

    def self.register_type(name, lookup)
      ["allocated", "retained"].product(["objects", "memory"]).each do |type, metric|
        full_name = "#{type}_#{metric}_by_#{name}"
        attr_accessor full_name

        @@lookups ||= []
        mapped = lookup

        if metric == "memory"
          mapped = lambda { |stat|
            [lookup.call(stat), stat.memsize]
          }
        end

        @@lookups << [full_name, mapped]

      end
    end

    register_type :gem, lambda { |stat|
                        Helpers.guess_gem("#{stat.file}")
                      }

    register_type :file, lambda { |stat|
                         stat.file || "(no name)"
                       }

    register_type :location, lambda { |stat|
                             "#{stat.file}:#{stat.line}"
                           }

    register_type :class, lambda { |stat|
                             "#{stat.class_name}"
                           }

    attr_accessor :strings_retained, :strings_allocated
    attr_accessor :total_retained, :total_allocated
    attr_accessor :total_retained_memsize, :total_allocated_memsize

    def self.from_raw(allocated, retained, top)
      self.new.register_results(allocated, retained, top)
    end

    def register_results(allocated, retained, top)
      @@lookups.each do |name, lookup|
        mapped = lambda { |tuple|
          lookup.call(tuple[1])
        }

        result =
            if name =~ /^allocated/
              allocated.top_n(top, &mapped)
            else
              retained.top_n(top, &mapped)
            end

        self.send "#{name}=", result
      end

      self.strings_retained = string_report(retained, top)

      self.total_allocated = allocated.count
      self.total_allocated_memsize = allocated.values.map(&:memsize).inject(:+) || 0
      self.total_retained = retained.count
      self.total_retained_memsize = retained.values.map(&:memsize).inject(:+) || 0

      self
    end

    StringStat = Struct.new(:string, :count, :location)

    def string_report(data, top)
      data
          .reject { |id, stat| stat.class_name != "String" }
          .map { |id, stat| [begin; ObjectSpace._id2ref(id); rescue; "__UNKNOWN__"; end, "#{stat.file}:#{stat.line}"] }
          .group_by { |string, location| string }
          .sort_by { |string, list| -list.count }
          .first(top)
          .map { |string, list| [string, list.group_by { |str, location| location }
          .map { |location, locations| [location, locations.count] }] }
    end

    def pretty_print(io = STDOUT, **options)
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
        stats.sort_by { |x, y| -y }.each do |location, count|
          io.puts "#{@colorize.path(count.to_s.rjust(10))}  #{location}"
        end
        io.puts
      end
      nil
    end

    def dump(description, data, io)
      io.puts description
      io.puts @colorize.line("-----------------------------------")
      if data
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


