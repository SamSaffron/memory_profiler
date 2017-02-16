require_relative 'test_reporter'

class TestReporterStartStop < TestReporter
  # This class extends TestReporter so it includes all of the tests from
  # TestReporter plus any additional test_* cases below and it
  # overrides create_report to use the start/stop methods

  def create_report(options={}, &profiled_block)
    profiled_block ||= -> { default_block }
    reporter = MemoryProfiler::Reporter.new(options)
    reporter.start
    profiled_block.call
    reporter.stop
  end

  def test_module_stop_with_no_start
    results = MemoryProfiler.stop
    assert_nil(results)
  end

  def test_module_double_start
    MemoryProfiler.start
    reporter = MemoryProfiler::Reporter.current_reporter

    MemoryProfiler.start
    same_reporter = MemoryProfiler::Reporter.current_reporter
    default_block
    results = MemoryProfiler.stop

    assert_equal(reporter, same_reporter)
    # Some extra here due to variables needed in the test above
    assert_equal(17, results.total_allocated)
  end

end
