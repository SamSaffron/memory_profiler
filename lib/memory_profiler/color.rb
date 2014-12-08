module MemoryProfiler
  module Color
    def black(str)
      "\033[30m#{str}\033[0m"
    end

    def red(str)
      "\033[31m#{str}\033[0m"
    end

    def green(str)
      "\033[32m#{str}\033[0m"
    end

    def brown(str)
      "\033[33m#{str}\033[0m"
    end

    def blue(str)
      "\033[34m#{str}\033[0m"
    end

    def magenta(str)
      "\033[35m#{str}\033[0m"
    end

    def cyan(str)
      "\033[36m#{str}\033[0m"
    end

    def gray(str)
      "\033[37m#{str}\033[0m"
    end

    def bg_black(str)
      "\033[40m#{str}\033[0m"
    end

    def bg_red(str)
      "\033[41m#{str}\033[0m"
    end

    def bg_green(str)
      "\033[42m#{str}\033[0m"
    end

    def bg_brown(str)
      "\033[43m#{str}\033[0m"
    end

    def bg_blue(str)
      "\033[44m#{str}\033[0m"
    end

    def bg_magenta(str)
      "\033[45m#{str}\033[0m"
    end

    def bg_cyan(str)
      "\033[46m#{str}\033[0m"
    end

    def bg_gray(str)
      "\033[47m#{str}\033[0m"
    end

    def bold(str)
      "\033[1m#{str}\033[22m"
    end

    def reverse_color(str)
      "\033[7m#{str}\033[27m"
    end

    def no_colors
      self.gsub /\033\[\d+m/, "";
    end
  end

  module NoColor
    [:black, :red, :green, :brown, :blue, :magenta, :cyan, :gray, :bg_black, :bg_red, :bg_green, :bg_brown, :bg_blue, :bg_magenta, :bg_cyan, :bg_gray, :bold, :reverse_color, :no_colors].each do |m|
      define_method m, ->(str) { str }
    end
  end
end
