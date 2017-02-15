require_relative 'test_helper'
require_relative 'test_reporter'

class TestStartStopApi < TestReporter

  def create_report(options={}, &yield_for_report_block)
    retained = []
    prof_block = report_block(retained, &yield_for_report_block)
    MemoryProfiler.start(options)
    prof_block.call
    MemoryProfiler.stop
  end

  def test_module_stop_with_no_start
    results = MemoryProfiler.stop
    assert_nil(results)
  end

  def test_module_double_start
    MemoryProfiler.start
    reporter = MemoryProfiler::Reporter.current_reporter

    # From create_report
    retained = []
    prof_block = report_block(retained)
    MemoryProfiler.start
    same_reporter = MemoryProfiler::Reporter.current_reporter
    prof_block.call
    results = MemoryProfiler.stop
    # end

    assert_equal(reporter, same_reporter)
    # Some extra here do to variables needed in the test above
    assert_equal(20, results.total_allocated)
  end

end
