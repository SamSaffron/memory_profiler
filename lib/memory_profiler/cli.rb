# frozen_string_literal: true

require "optparse"

module MemoryProfiler
  class CLI
    STATUS_SUCCESS = 0
    STATUS_ERROR   = 1

    def run(argv)
      options = {}
      parser = option_parser(options)
      parser.parse!(argv)

      options = defaults.merge(options)

      # Make sure the user specified at least one file
      unless (script = argv.shift)
        puts parser
        puts ""
        puts "Must specify a script to run"
        return STATUS_ERROR
      end

      MemoryProfiler.start(reporter_options(options))
      load script

      STATUS_SUCCESS
    rescue OptionParser::InvalidOption, OptionParser::InvalidArgument, OptionParser::MissingArgument => e
      puts parser
      puts e.message
      STATUS_ERROR
    ensure
      report = MemoryProfiler.stop
      report&.pretty_print(**results_options(options))
    end

    private

    def option_parser(options)
      OptionParser.new do |opts|
        opts.banner = <<~BANNER
          ruby-memory-profiler #{MemoryProfiler::VERSION}
          Usage: ruby-memory-profiler [options] <script.rb> [--] [script-options]
        BANNER

        opts.separator ""
        opts.separator "Options:"

        # Reporter options
        opts.on("-m", "--max=NUM", Integer, "Max number of entries to output.") do |arg|
          options[:top] = arg
        end

        opts.on("--classes=CLASSES", Array, "A class or an array of classes you explicitly want to trace.") do |arg|
          options[:trace] = arg.map { |klass| Object.const_get(klass) }
        end

        opts.on("--ignore-files=REGEXP", "A regular expression used to exclude certain files from tracing.") do |arg|
          options[:ignore_files] = "#{arg}|memory_profiler/lib"
        end

        opts.on("--allow-files=FILES", Array, "A string or array of strings to selectively include in tracing.") do |arg|
          options[:allow_files] = arg
        end

        # Results options
        opts.on("-o", "--out=FILE", "Write output to a file instead of STDOUT.") do |arg|
          options[:to_file] = arg
        end

        opts.on("--[no-]color", "Force color output on or off.") do |arg|
          options[:color_output] = arg
        end

        opts.on("--retained-strings=NUM", Integer, "How many retained strings to print.") do |arg|
          options[:retained_strings] = arg
        end

        opts.on("--allocated-strings=NUM", Integer, "How many allocated strings to print.") do |arg|
          options[:allocated_strings] = arg
        end

        opts.on("--[no-]detailed-report", "Print detailed information.") do |arg|
          options[:detailed_report] = arg
        end

        opts.on("--scale-bytes", "Calculates unit prefixes for the numbers of bytes.") do
          options[:scale_bytes] = true
        end

        opts.on("--normalize-paths", "Print location paths relative to gem's source directory.") do
          options[:normalize_paths] = true
        end

        opts.on_tail("-h", "--help", "Show help message.") do
          puts opts
          exit
        end

        opts.on_tail("-v", "--version", "Show version.") do
          puts "ruby-memory-profiler #{MemoryProfiler::VERSION}"
          exit
        end
      end
    end

    def reporter_options(options)
      options.select { |k, _v| [:top, :trace, :ignore_files, :allow_files].include?(k) }
    end

    def results_options(options)
      options.select { |k, _v| [:to_file, :color_output, :retained_strings, :allocated_strings,
                    :detailed_report, :scale_bytes, :normalize_paths].include?(k) }
    end

    def defaults
      {
        ignore_files: "memory_profiler/lib"
      }
    end
  end
end
