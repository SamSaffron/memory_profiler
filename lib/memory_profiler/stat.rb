module MemoryProfiler
  class Stat

    attr_reader :class_name, :gem, :file, :line, :location, :memsize, :string_value

    def initialize(class_name, gem, file, line, memsize, string_value)
      @class_name = class_name
      @gem = gem

      @file = file || "(no name)".freeze
      @line = line
      @location = "#{file}:#{line}"

      @memsize = memsize
      @string_value = string_value
    end

  end
end
