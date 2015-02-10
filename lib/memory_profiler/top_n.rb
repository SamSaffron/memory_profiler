module MemoryProfiler
  module TopN
    # Efficient mechanism for finding top_n entries in a list
    # optional block can specify custom element and weight
    def top_n(max = 10)

      sorted =
        if block_given?
          self.map { |row|
            yield(row)
          }
        else
          self.dup
        end

      sorted.compact!
      sorted.sort!

      found = []

      last = sorted[0]
      count = 0
      lowest_count = 0

      sorted << nil

      sorted.each do |row|

        current_item, current_count = row

        unless current_item == last
          if count > lowest_count
            found << {data: last, count: count}
          end

          if found.length > max
            found.sort!{|x,y| x[:count] <=> y[:count] }
            found.delete_at(0)
            lowest_count = found[0][:count]
          end

          count = 0
          last = current_item
        end

        count += (current_count || 1) unless row.nil?
      end

      found
        .sort!{|x,y| x[:count] <=> y[:count] }
        .reverse
    end
  end
end
