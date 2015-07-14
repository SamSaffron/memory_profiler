module MemoryProfiler
  module TopN
    # Fast approach for determining the top_n entries in a Hash of Stat objects.
    # Returns results for both memory (memsize summed) and objects allocated (count) as a tuple.
    def top_n(max, metric)

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
