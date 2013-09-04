require "memory_profiler/version"
require "memory_profiler/results"
require "memory_profiler/reporter"

module MemoryProfiler
  def self.report
    Reporter.measure do
      yield
    end
  end
end


