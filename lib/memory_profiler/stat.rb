module MemoryProfiler
  class Stat

    attr_reader :class_name, :file, :line, :class_path, :memsize

    def initialize(class_name, file, line, class_path, memsize)
      @class_name = class_name
      @file = file
      @line = line
      @class_path = class_path
      @memsize = memsize
    end

    def gem
      @gem ||= Helpers.guess_gem(file)
    end

    def location
      @location ||= "#{file}:#{line}"
    end

  end
end
