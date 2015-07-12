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

    # Fast approach for determining the top_n entries in a list of Stat objects.
    # Returns results for both memory (memsize summed) and objects allocated (count) as a tuple.
    def max_n(max, metric)

      stats_by_metric = self.values.map! { |stat| [stat.send(metric), stat.memsize] }

      stat_totals = stats_by_metric.group_by { |metric_value, _memsize| metric_value }.
          map { |key, values| [key, values.reduce(0) { |sum, item| _key, memsize = item ; sum + memsize }, values.size] }

      stats_by_memsize = stat_totals.sort_by! { |data| -data[1] }.first(max).
          map! { |metric, memsize, _count| { data: metric, count: memsize } }
      stats_by_count   = stat_totals.sort_by! { |data| -data[2] }.first(max).
          map! { |metric, _memsize, count| { data: metric, count: count } }

      [stats_by_memsize, stats_by_count]

    end
  end
end
