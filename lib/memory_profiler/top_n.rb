module MemoryProfiler
  module TopN
    # Fast approach for determining the top_n entries in a Hash of Stat objects.
    # Returns results for both memory (memsize summed) and objects allocated (count) as a tuple.
    def top_n(max, metric_method)

      stat_totals = self.values.group_by(&metric_method).map do |metric, stats|
        [metric, stats.reduce(0) { |sum, stat| sum + stat.memsize }, stats.size]
      end

      stats_by_memsize = stat_totals.sort_by! { |metric, memsize, _count| [-memsize, metric] }.take(max).
          map! { |metric, memsize, _count| { data: metric, count: memsize } }
      stats_by_count = stat_totals.sort_by! { |metric, _memsize, count| [-count, metric] }.take(max).
          map! { |metric, _memsize, count| { data: metric, count: count } }

      [stats_by_memsize, stats_by_count]

    end
  end
end
