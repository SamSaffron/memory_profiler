module MemoryProfiler
  class Results

    def self.register_type(name, lookup)
      ["allocated","retained"].product(["objects","memory"]).each do |type, metric|
        full_name = "#{type}_#{metric}_by_#{name}"
        attr_accessor full_name

        @@lookups ||= []
        mapped = lookup

        if metric == "memory"
          mapped = lambda{|stat|
            [lookup.call(stat), stat.memsize]
          }
        end

        @@lookups << [full_name, mapped]

      end
    end

    register_type :gem, lambda{|stat|
      Helpers.guess_gem("#{stat.file}")
    }

    register_type :file, lambda{|stat|
      stat.file
    }

    register_type :location, lambda{|stat|
      "#{stat.file}:#{stat.line}"
    }

    attr_accessor :total_allocated
    attr_accessor :total_retained

    def self.from_raw(allocated, retained, top)
      self.new.register_results(allocated,retained,top)
    end

    def register_results(allocated, retained, top)
      @@lookups.each do |name, lookup|
        mapped = lambda{|tuple|
            lookup.call(tuple[1])
        }

        result =
          if name =~ /^allocated/
            allocated.top_n(top, &mapped)
          else
            retained.top_n(top, &mapped)
          end

        self.send "#{name}=", result
        self.total_allocated = allocated.count
        self.total_retained = retained.count
      end

      self
    end

    def pretty_print(io = STDOUT)
      io.puts "Total allocated #{total_allocated}"
      io.puts "Total retained #{total_retained}"
      io.puts
      ["allocated","retained"]
        .product(["memory", "objects"])
        .product(["gem", "file", "location"])
        .each do |(type, metric), name|
        dump "#{type} #{metric} by #{name}", self.send("#{type}_#{metric}_by_#{name}"), io
      end
    end

    def dump(description, data, io)
      io.puts description
      io.puts "-----------------------------------"
      if data
        data.each do |item|
          io.puts "#{item[:data]} x #{item[:count]}"
        end
      else
        io.puts "NO DATA"
      end
      io.puts
    end
  end
end
