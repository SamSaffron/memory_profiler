module MemoryProfiler
  class Stat

    attr_reader :klass, :file, :line, :class_path, :memsize, :string_value

    def initialize(klass, file, line, class_path, memsize, string_value)
      @klass = klass
      @file = file
      @line = line
      @class_path = class_path
      @memsize = memsize
      @string_value = string_value
    end

    def gem
      @gem ||= Helpers.guess_gem(file)
    end

    def location
      @location ||= "#{file}:#{line}"
    end

    def class_name
      @class_name ||= klass.name rescue "BasicObject".freeze
    end
  end
end
