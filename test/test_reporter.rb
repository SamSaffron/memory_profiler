require_relative 'test_helper'

class TestReporter < Minitest::Test

  def setup
    @retained = []
  end

  # Reusable block for reporting.
  def default_block
    # Create an object from a gem outside memory_profiler which allocates
    # its own objects internally
    MiniTest::Reporter.new

    # Create 10 strings
    10.times { |i| i.to_s }

    # Create 1 string and retain it
    @retained << "hello"

    # Create one object defined by the test_helpers file
    Foo.new
  end

  # Shared method that creates a Results with 1 retained object using options provided
  def create_report(options={}, &profiled_block)
    profiled_block ||= -> { default_block }
    MemoryProfiler::Reporter.report(options, &profiled_block)
  end

  def test_basic_object
    results = create_report do
      @retained << BasicObject.new
      @retained << BasicObjectSubclass.new
    end
    assert_equal(2, results.total_allocated)
    assert_equal(2, results.total_retained)
    assert_equal('BasicObject', results.allocated_objects_by_class[0][:data])
    assert_equal('BasicObjectSubclass', results.allocated_objects_by_class[1][:data])
    assert_equal(2, results.retained_objects_by_location.length)
  end

  def test_anonymous_class_object
    anon_class1 = Class.new
    anon_class2 = Class.new(String)
    results = create_report do
      @retained << anon_class1.new
      @retained << anon_class2.new
    end
    assert_equal(2, results.total_allocated)
    assert_equal(2, results.total_retained)
    assert_equal('<<Unknown>>', results.allocated_objects_by_class[0][:data])
    assert_equal(2, results.retained_objects_by_location.length)
  end

  def test_nil_reporting_class
    results = create_report do
      @retained << NilReportingClass.new
    end
    assert_equal(1, results.total_allocated)
    assert_equal(1, results.total_retained)
    assert_equal('NilReportingClass', results.allocated_objects_by_class[0][:data])
    assert_equal(1, results.retained_objects_by_location.length)
  end

  def test_string_reporting_class
    results = create_report do
      @retained << StringReportingClass.new
    end
    assert_equal(1, results.total_allocated)
    assert_equal(1, results.total_retained)
    assert_equal('StringReportingClass', results.allocated_objects_by_class[0][:data])
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
    retained = []
    results = create_report do
      retained << NonStringNamedClass.new
      retained << "test"
    end

    io = StringIO.new
    results.pretty_print io

    assert_equal(2, results.total_allocated)
    assert_equal(2, results.total_retained)
    assert_equal('String', results.allocated_objects_by_class[0][:data])
    assert_equal('Symbol', results.allocated_objects_by_class[1][:data])
    assert_equal(2, results.retained_objects_by_location.length)
  end

  def test_exception_handling
    results = nil
    assert_raises Exception do
      results = create_report do
        @retained << "hello"
        raise Exception, "Raising exception"
      end
    end
    assert_nil(results)
    refute(GC.enable, "Re-enabling GC should return false because it is already enabled")

    # Verify that memory_profiler is not reporting on itself following the exception
    results = create_report(allow_files: 'lib/memory_profiler')
    assert_equal(0, results.total_allocated)
  end

  def test_strings_report
    # Note: There is something strange about `string *`. The first time it is dup'd it allocates 2 objects.
    string_250 = String.new("1234567890" * 25)
    string_300 = String.new("1234567890" * 30)

    results = create_report do
      string_250.dup
      string_250.dup
      5.times { string_250.dup }
      string_300.dup
    end

    assert_equal(8, results.total_allocated, "8 strings should be allocated")
    assert_equal(2, results.strings_allocated.size, "2 unique strings should be observed")
    assert_equal(results.strings_allocated[0][0],
                 results.strings_allocated[1][0], "The 2 unique strings have the same summary string")
    assert_equal(200, results.strings_allocated[0][0].size, "The first string summary should be shortened to 200 chars")
    assert_equal(3, results.strings_allocated[0][1].size, "The first string was allocated in 3 locations")
    assert_equal(5, results.strings_allocated[0][1][0][1], "The first string was allocated in 5 times in the first location")
  end

end
