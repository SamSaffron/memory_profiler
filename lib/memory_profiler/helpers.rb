module MemoryProfiler
  class Helpers

    def initialize
      @gem_guess_cache = Hash.new
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

  end
end
