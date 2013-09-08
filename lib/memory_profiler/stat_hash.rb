module MemoryProfiler
  class StatHash < Hash
    include TopN
  end
end
