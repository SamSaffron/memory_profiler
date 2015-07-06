module MemoryProfiler
  class Stat

    attr_reader :klass, :file, :line, :class_path, :memsize, :string_value, :gem, :location, :class_name

    def initialize(klass, file, line, class_path, memsize, string_value)
      @klass = klass
      @file = file || "(no name)".freeze
      @line = line
      @class_path = class_path
      @memsize = memsize
      @string_value = string_value

      @gem = Helpers.guess_gem(file)
      @location = "#{file}:#{line}"
      @class_name = klass.name rescue "BasicObject".freeze
    end

  end
end
