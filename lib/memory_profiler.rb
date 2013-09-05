require "memory_profiler/version"
require "memory_profiler/results"
require "memory_profiler/reporter"

module MemoryProfiler
  def self.report(top=50,&block)
    Reporter.report(top,&block)
  end
end


