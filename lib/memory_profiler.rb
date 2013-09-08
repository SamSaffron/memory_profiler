require "memory_profiler/version"
require "memory_profiler/helpers"
require "memory_profiler/top_n"
require "memory_profiler/stat"
require "memory_profiler/stat_hash"
require "memory_profiler/results"
require "memory_profiler/reporter"

module MemoryProfiler
  def self.report(top=50,&block)
    Reporter.report(top,&block)
  end
end


