# frozen_string_literal: true

module MemoryProfiler
  class Stat

    attr_reader :class_name, :gem, :file, :location, :memsize, :string_value

    attr_reader :shared

    def initialize(class_name, gem, file, location, memsize, string_value, shared)
      @class_name = class_name
      @gem = gem

      @file = file
      @location = location

      @memsize = memsize
      @string_value = string_value

      @shared = shared
    end

  end
end
