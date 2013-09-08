module MemoryProfiler
  Stat = Struct.new(:class_name, :file, :line, :class_path, :method_id, :memsize)
end
