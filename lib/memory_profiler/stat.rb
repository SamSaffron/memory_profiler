module MemoryProfiler
  class Stat

    attr_reader :class_name, :gem, :file, :location, :memsize, :string_value, :md5

    def initialize(class_name, gem, file, location, memsize, string_value, md5)
      @class_name = class_name
      @gem = gem

      @file = file
      @location = location

      @memsize = memsize
      @string_value = string_value
      @md5 = md5
    end

  end
end
