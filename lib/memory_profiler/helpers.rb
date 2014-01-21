module MemoryProfiler
  module Helpers
    def self.guess_gem(path)
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

    # helper to work around GC.start not freeing everything
    def self.full_gc
      # TODO: discuss with @tmm1 and @ko1 if the while loop is needed
      GC.start(full_mark: true) while new_count = decreased_count(new_count)
    end

    def self.decreased_count(old)
      count = count_objects
      if !old || count < old
        count
      else
        nil
      end
    end

    def self.count_objects
      i = 0
      ObjectSpace.each_object do |obj|
        i += 1
      end
    end
  end
end
