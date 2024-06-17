# frozen_string_literal: true

require_relative 'test_helper'

class TestCLI < Minitest::Test
  def setup
    @cli = MemoryProfiler::CLI.new
    @script_file = File.expand_path("fixtures/script.rb", __dir__)
  end

  def test_traces_only_specified_classes
    out, _err = capture_io do
      @cli.run(["--classes=String", @script_file])
    end

    assert_includes out, "String"
    refute_includes out, "Array"
  end

  def test_ignore_specific_files
    out, _err = capture_io do
      @cli.run([@script_file])
    end
    assert_includes out, "set.rb"

    out, _err = capture_io do
      @cli.run(["--ignore-files=set.rb", @script_file])
    end
    refute_includes out, "set.rb"
  end

  def test_allow_specific_files
    assert_output(/set\.rb/) { @cli.run([@script_file]) }

    out, _err = capture_io do
      @cli.run(["--allow-files=longhorn", @script_file])
    end
    refute_includes out, "set.rb"
  end

  def test_redirects_output_to_specific_file
    tmpdir = File.expand_path("../tmp", __dir__)
    Dir.mkdir(tmpdir) unless Dir.exist?(tmpdir)
    outfile = File.join(tmpdir, "out.txt")

    assert_silent { @cli.run(["--out", outfile, @script_file]) }
    assert_includes File.read(outfile), "Total allocated:"
  end

  def test_color_output
    assert_output(/\033/) { @cli.run(["--color", @script_file]) }
  end

  def test_no_color_output
    out, _err = capture_io do
      @cli.run(["--no-color", @script_file])
    end
    refute_includes out, "\033"
  end

  def test_detailed_report
    assert_output(/allocated objects by location\n--------/) do
      @cli.run(["--detailed", @script_file])
    end
  end

  def test_no_detailed_report
    out, _err = capture_io do
      @cli.run(["--no-detailed", @script_file])
    end
    refute_includes out, "allocated objects by location\n--------"
  end

  def test_scale_bytes
    assert_output(/\d kB/) { @cli.run(["--scale-bytes", @script_file]) }
  end

  def test_normalize_paths
    out, _err = capture_io do
      @cli.run(["--normalize-paths", @script_file])
    end

    assert_match(%r!\d+\s{2}longhorn-0.1.0/lib/longhorn.rb:\d+!, out)
    assert_match(%r!ruby/lib/\S*set.rb!, out)
  end

  def test_pretty
    out, _err = capture_io do
      @cli.run(["--pretty", @script_file])
    end

    assert_match(/\d kB/, out)
    assert_match(%r!\d+\s{2}longhorn-0.1.0/lib/longhorn.rb:\d+!, out)
    assert_match(%r!ruby/lib/\S*set.rb!, out)
  end

  def test_prints_help_when_script_not_specified
    assert_output(/Must specify a script to run/) { @cli.run([]) }
  end

  def test_returns_success_when_everything_ok
    capture_io do
      result = @cli.run([@script_file])
      assert_equal 0, result
    end
  end

  def test_returns_error_when_script_not_specified
    capture_io do
      result = @cli.run([])
      assert_equal 1, result
    end
  end
end
