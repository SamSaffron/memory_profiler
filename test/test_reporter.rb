require_relative 'test_helper'

class TestReporter < Minitest::Test

  class Foo; end
  class NilReportingClass
    def class
      # return nil when asked for the class
      nil
    end
  end
  class StringReportingClass
    def class
      # return a string when asked for the class
      'StringReportingClass'
    end
  end
  class NonStringNamedClass
    def self.name
      :Symbol
    end
  end

  # Shared method that creates a Results with 1 retained object using options provided
  def create_report(options={})
    retained = []
    results = MemoryProfiler::Reporter.report(options) do
      # Create an object from a gem outside memory_profiler which allocates
      # its own objects internally
      minitest_report = MiniTest::Reporter.new

      # Create 10 strings
      10.times { |i| i.to_s }

      # Create 1 string and retain it
      retained << "hello"

      # Create one object defined by this file
      Foo.new
    end
    results
  end

  def test_basic_object
    retained = []
    results = MemoryProfiler::Reporter.report do
      retained << BasicObject.new
    end
    assert_equal(1, results.total_allocated)
    assert_equal(1, results.total_retained)
    assert_equal('<<Unknown>>', results.allocated_objects_by_class[0][:data])
    assert_equal(1, results.retained_objects_by_location.length)
  end

  def test_nil_reporting_class
    retained = []
    results = MemoryProfiler::Reporter.report do
      retained << NilReportingClass.new
    end
    assert_equal(1, results.total_allocated)
    assert_equal(1, results.total_retained)
    assert_equal('<<Unknown>>', results.allocated_objects_by_class[0][:data])
    assert_equal(1, results.retained_objects_by_location.length)
  end

  def test_string_reporting_class
    retained = []
    results = MemoryProfiler::Reporter.report do
      retained << StringReportingClass.new
    end
    assert_equal(1, results.total_allocated)
    assert_equal(1, results.total_retained)
    assert_equal('<<Unknown>>', results.allocated_objects_by_class[0][:data])
    assert_equal(1, results.retained_objects_by_location.length)
  end

  def test_counts
    results = create_report
    assert_equal(16, results.total_allocated)
    assert_equal(1, results.total_retained)
    assert_equal(1, results.retained_objects_by_location.length)
  end

  def test_class_tracing_with_array
    results = create_report(:trace => [Foo])
    assert_equal(1, results.total_allocated)
    assert_equal(0, results.total_retained)
  end

  def test_class_tracing_with_value
    results = create_report(:trace => Foo)
    assert_equal(1, results.total_allocated)
    assert_equal(0, results.total_retained)
  end

  def test_ignore_file_with_regex
    results = create_report(:ignore_files => /test_reporter\.rb/)
    assert_equal(3, results.total_allocated)
    assert_equal(0, results.total_retained)
  end

  def test_ignore_file_with_string
    results = create_report(:ignore_files => 'test_reporter.rb|another_file.rb')
    assert_equal(3, results.total_allocated)
    assert_equal(0, results.total_retained)
  end

  def test_allow_files_with_string
    results = create_report(:allow_files => 'test_reporter')
    assert_equal(13, results.total_allocated)
    assert_equal(1, results.total_retained)
  end

  def test_allow_files_with_array
    results = create_report(:allow_files => ['test_reporter', 'another_file'])
    assert_equal(13, results.total_allocated)
    assert_equal(1, results.total_retained)
  end

  def test_no_color_output
    results = create_report
    io = StringIO.new
    results.pretty_print io, color_output: false
    assert(!io.string.include?("\033"), 'excludes color information')
  end

  def test_color_output
    results = create_report
    io = StringIO.new
    results.pretty_print io, color_output: true
    assert(io.string.include?("\033"), 'includes color information')
  end

  class StdoutMock < StringIO
    def isatty
      true
    end
  end

  def test_color_output_defaults_to_true_when_run_from_tty
    results = create_report
    io = StdoutMock.new
    results.pretty_print io
    assert(io.string.include?("\033"), 'includes color information')
  end

  def test_mono_output_defaults_to_true_when_not_run_from_tty
    results = create_report
    io = StringIO.new
    results.pretty_print io
    assert(!io.string.include?("\033"), 'excludes color information')
  end

  def test_reports_can_be_reused_with_different_color_options
    results = create_report

    io = StringIO.new
    results.pretty_print io, color_output: true
    assert(io.string.include?("\033"), 'includes color information')

    io = StringIO.new
    results.pretty_print io, color_output: false
    assert(!io.string.include?("\033"), 'excludes color information')
  end

  def test_non_string_named_class
    report = MemoryProfiler.report do
      NonStringNamedClass.new
      "test"
    end

    io = StringIO.new
    report.pretty_print io
  end

end
