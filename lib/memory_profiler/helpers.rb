require 'digest'

module MemoryProfiler
  class Helpers
    STRING_MAX = 199 # 200 chars

    def initialize
      @gem_guess_cache = Hash.new
      @location_cache = Hash.new { |h,k| h[k] = Hash.new.compare_by_identity }
      @class_name_cache = Hash.new.compare_by_identity
      @digest_cache = Hash.new
    end

    def guess_gem(path)
      @gem_guess_cache[path] ||=
        if /(\/gems\/.*)*\/gems\/(?<gemname>[^\/]+)/ =~ path
          gemname
        elsif /\/rubygems[\.\/]/ =~ path
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

    def lookup_class_name(klass)
      @class_name_cache[klass] ||= ((klass.is_a?(Class) && klass.name) || '<<Unknown>>').to_s
    end

    def string_summary(string)
      string[0..STRING_MAX]
    end

    def lookup_string_digest(string)
      @digest_cache[string] ||= Digest::MD5.hexdigest(string)
    end
  end
end
