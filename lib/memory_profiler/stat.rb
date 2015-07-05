module MemoryProfiler
  class Stat

    attr_reader :class_name, :file, :line, :class_path, :method_id, :memsize

    def initialize(class_name, file, line, class_path, method_id, memsize)
      @class_name = class_name
      @file = file
      @line = line
      @class_path = class_path
      @method_id = method_id
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
