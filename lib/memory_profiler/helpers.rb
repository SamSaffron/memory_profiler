module MemoryProfiler
  class Helpers

    def initialize
      @gem_guess_cache = Hash.new
      @location_cache = Hash.new({})
    end

    def guess_gem(path)
      @gem_guess_cache[path] ||=
        if /(\/gems\/.*)*\/gems\/(?<gem>[^\/]+)/ =~ path
          gem
        elsif /\/rubygems\// =~ path
          "rubygems".freeze
        elsif /(?<app>[^\/]+\/(bin|app|lib))/ =~ path
          app
        else
          "other".freeze
        end
    end

    def lookup_location(file, line)
      @location_cache[file][line] ||= "#{file}:#{line}"
    end

  end
end
