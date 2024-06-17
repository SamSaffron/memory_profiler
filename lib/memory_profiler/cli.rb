# frozen_string_literal: true

require "optparse"

module MemoryProfiler
  class CLI
    BIN_NAME     = "ruby-memory-profiler"
    VERSION_INFO = "#{BIN_NAME}  #{MemoryProfiler::VERSION}"

    STATUS_SUCCESS = 0
    STATUS_ERROR   = 1

    DEFAULTS = {
      ignore_files: "memory_profiler/lib"
    }.freeze

    def run(argv)
      options = {}
      parser = option_parser(options)
      parser.parse!(argv)

      options = DEFAULTS.merge(options)

      # Make sure the user specified at least one file
      unless (script = argv.shift)
        puts parser
        puts ""
        puts "#{VERSION_INFO}  |  ERROR: Must specify a script to run"
        return STATUS_ERROR
      end

      if script == "run"
        # We are profiling a command.
        profile_command(options, argv)
      else
        # We are profiling a ruby file.
        begin
          MemoryProfiler.start(options)
          load(script)
        ensure
          report = MemoryProfiler.stop
          report.pretty_print(**options)
        end
        STATUS_SUCCESS
      end
    rescue OptionParser::InvalidOption, OptionParser::InvalidArgument, OptionParser::MissingArgument => e
      puts parser
      puts e.message
      STATUS_ERROR
    end

    private

    def option_parser(options)
      OptionParser.new do |opts|
        opts.banner = <<~BANNER

              #{VERSION_INFO}
              A Memory Profiler for Ruby

          Usage:
              #{BIN_NAME} [options] run [--] command [command-options]
        BANNER

        opts.separator ""
        opts.separator "Options:"

        # Reporter options
        opts.on("-m", "--max=NUM", Integer, "Max number of entries to output. (Defaults to 50)") do |arg|
          options[:top] = arg
        end

        opts.on("--classes=CLASSES", Array, "A class or list of classes you explicitly want to trace.") do |arg|
          options[:trace] = arg.map { |klass| Object.const_get(klass) }
        end

        opts.on("--ignore-files=REGEXP", "A regular expression used to exclude certain files from tracing.") do |arg|
          options[:ignore_files] = "#{arg}|memory_profiler/lib"
        end

        opts.on("--allow-files=FILES", Array, "A string or list of strings to selectively include in tracing.") do |arg|
          options[:allow_files] = arg
        end

        opts.separator ""

        # Results options
        opts.on("-o", "--out=FILE", "Write output to a file instead of STDOUT.") do |arg|
          options[:to_file] = arg
        end

        opts.on("--[no-]color", "Force color output on or off. (Enabled by default)") do |arg|
          options[:color_output] = arg
        end

        opts.on("--retained-strings=NUM", Integer, "How many retained strings to print.") do |arg|
          options[:retained_strings] = arg
        end

        opts.on("--allocated-strings=NUM", Integer, "How many allocated strings to print.") do |arg|
          options[:allocated_strings] = arg
        end

        opts.on("--[no-]detailed", "Print detailed information. (Enabled by default)") do |arg|
          options[:detailed_report] = arg
        end

        opts.on("--scale-bytes", "Calculates unit prefixes for the numbers of bytes.") do
          options[:scale_bytes] = true
        end

        opts.on("--normalize-paths", "Print location paths relative to gem's source directory.") do
          options[:normalize_paths] = true
        end

        opts.on("--pretty", "Easily enable options 'scale-bytes' and 'normalize-paths'") do
          options[:scale_bytes] = options[:normalize_paths] = true
        end

        opts.separator ""

        opts.on_tail("-h", "--help", "Show this help message.") do
          puts opts
          exit
        end

        opts.on_tail("-v", "--version", "Show program version.") do
          puts VERSION_INFO
          exit
        end
      end
    end

    def profile_command(options, argv)
      env = {}
      env["MEMORY_PROFILER_OPTIONS"] = serialize_hash(options) if options.any?
      gem_path = File.expand_path('../', __dir__)
      env["RUBYOPT"] = "-I #{gem_path} -r memory_profiler/autorun #{ENV['RUBYOPT']}"
      exec(env, *argv)
    end

    def serialize_hash(hash)
      [Marshal.dump(hash)].pack("m0")
    end
  end
end
