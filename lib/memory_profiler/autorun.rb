# frozen_string_literal: true

require "memory_profiler"

def deserialize_hash(data)
  Marshal.load(data.unpack1("m0")) if data
end

options = deserialize_hash(ENV["MEMORY_PROFILER_OPTIONS"]) || {}

at_exit do
  report = MemoryProfiler.stop
  report.pretty_print(**options)
end

MemoryProfiler.start(options)
