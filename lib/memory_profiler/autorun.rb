# frozen_string_literal: true

require "memory_profiler"
require "base64"

def deserialize_hash(data)
  Marshal.load(Base64.urlsafe_decode64(data)) if data
end

options = deserialize_hash(ENV["MEMORY_PROFILER_OPTIONS"]) || {}

at_exit do
  report = MemoryProfiler.stop
  report.pretty_print(**options)
end

MemoryProfiler.start(options)
