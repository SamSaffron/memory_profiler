module Color
  refine String do
    def black;
      "\033[30m#{self}\033[0m"
    end

    def red;
      "\033[31m#{self}\033[0m"
    end

    def green;
      "\033[32m#{self}\033[0m"
    end

    def brown;
      "\033[33m#{self}\033[0m"
    end

    def blue;
      "\033[34m#{self}\033[0m"
    end

    def magenta;
      "\033[35m#{self}\033[0m"
    end

    def cyan;
      "\033[36m#{self}\033[0m"
    end

    def gray;
      "\033[37m#{self}\033[0m"
    end

    def bg_black;
      "\033[40m#{self}\033[0m"
    end

    def bg_red;
      "\033[41m#{self}\033[0m"
    end

    def bg_green;
      "\033[42m#{self}\033[0m"
    end

    def bg_brown;
      "\033[43m#{self}\033[0m"
    end

    def bg_blue;
      "\033[44m#{self}\033[0m"
    end

    def bg_magenta;
      "\033[45m#{self}\033[0m"
    end

    def bg_cyan;
      "\033[46m#{self}\033[0m"
    end

    def bg_gray;
      "\033[47m#{self}\033[0m"
    end

    def bold;
      "\033[1m#{self}\033[22m"
    end

    def reverse_color;
      "\033[7m#{self}\033[27m"
    end

    def no_colors;
      self.gsub /\033\[\d+m/, "";
    end
  end
end

using Color

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
                         stat.file
                       }

    register_type :location, lambda { |stat|
                             "#{stat.file}:#{stat.line}"
                           }

    attr_accessor :strings_retained, :strings_allocated
    attr_accessor :total_retained, :total_allocated

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
      self.total_retained = retained.count

      self
    end

    StringStat = Struct.new(:string, :count, :location)

    def string_report(data, top)
      data
          .reject { |id, stat| stat.class_name != "String" }
          .map { |id, stat| [ObjectSpace._id2ref(id), "#{stat.file}:#{stat.line}"] }
          .group_by { |string, location| string }
          .sort_by { |string, list| -list.count }
          .first(top)
          .map { |string, list| [string, list.group_by { |str, location| location }
                                             .map { |location, locations| [location, locations.count] }] }
    end

    def pretty_print(io = STDOUT)
      io.puts "Total allocated #{total_allocated}"
      io.puts "Total retained #{total_retained}"
      io.puts
      ["allocated", "retained"]
          .product(["memory", "objects"])
          .product(["gem", "file", "location"])
          .each do |(type, metric), name|
        dump "#{type} #{metric} by #{name}", self.send("#{type}_#{metric}_by_#{name}"), io
      end

      io.puts
      dump_strings(io, "Allocated", strings_allocated)
      io.puts
      dump_strings(io, "Retained", strings_retained)
      nil
    end

    def dump_strings(io, title, strings)
      return unless strings
      io.puts "#{title} String Report"
      io.puts "-----------------------------------".gray
      strings.each do |string, stats|
        io.puts "#{stats.reduce(0) { |a, b| a + b[1] }.to_s.ljust(10)} #{string[0..200].inspect.green}"
        stats.sort_by { |x, y| -y }.each do |location, count|
          io.puts "#{count.to_s.ljust(10).gray} #{location}"
        end
        io.puts
      end
      nil
    end

    def dump(description, data, io)
      io.puts description
      io.puts "-----------------------------------".gray
      if data
        data.each do |item|
          io.puts "#{item[:count].to_s.ljust(10)} #{item[:data]}"
        end
      else
        io.puts "NO DATA"
      end
      io.puts
    end
  end
end
