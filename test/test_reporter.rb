require_relative 'test_helper'

class TestReporter < Minitest::Test

  class Foo; end

  def allocate_strings(n)
    n.times do
      ""
    end
  end

  def test_counts
    a = nil
    result = MemoryProfiler::Reporter.report do
      allocate_strings(10)
      a = "hello"
    end
    assert_equal(11, result.total_allocated)
    assert_equal(1, result.total_retained)
    assert_equal(1, result.retained_objects_by_location.length)
  end

  def test_class_tracing
    result = MemoryProfiler::Reporter.report(:trace => [Foo]) do
      "hello"
      "hello"
      Foo.new
    end
    assert_equal(1, result.total_allocated)
    assert_equal(0, result.total_retained)
  end

  def test_ignore_file
    result = MemoryProfiler::Reporter.report(:ignore_files => /test_reporter\.rb/) do
      "hello"
      "hello"
      Foo.new
    end

    assert_equal(0, result.total_allocated)
    assert_equal(0, result.total_retained)
  end

  def test_no_color_output
    report = MemoryProfiler::Reporter.report(color_output: false) do
      allocate_strings(10)
    end
    io = StringIO.new
    report.pretty_print io
    puts io.string
    assert(!io.string.include?("\033"))
  end

  def test_color_output
    report = MemoryProfiler::Reporter.report(color_output: true) do
      allocate_strings(10)
    end
    io = StringIO.new
    report.pretty_print io
    puts io.string
    assert(io.string.include?("\033"))
  end


end
