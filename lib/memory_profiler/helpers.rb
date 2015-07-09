module MemoryProfiler
  module Helpers
    def self.guess_gem(path)
      @@gem_guess_cache ||= Hash.new
      @@gem_guess_cache[path] ||=
        if /(\/gems\/.*)*\/gems\/(?<gem>[^\/]+)/ =~ path
          gem
        elsif /\/rubygems\// =~ path
          "rubygems"
        elsif /(?<app>[^\/]+\/(bin|app|lib))/ =~ path
          app
        else
          "other"
        end
    end

    def self.reset_gem_guess_cache
      @@gem_guess_cache = Hash.new
    end
  end
end
