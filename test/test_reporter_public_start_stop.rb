# frozen_string_literal: true

require_relative 'test_reporter'

class TestReporterPublicStartStop < TestReporter
  # This class extends TestReporter so it includes all of the tests from
  # TestReporter plus any additional test_* cases below and it
  # overrides create_report to use the start/stop methods

  # This specifically tests the public API of the start and stop methods of the
  # MemoryProfiler module itself, and even does some extra tests exercising
  # edge case handling of `current_reporter` which is done in those methods.
  #
  # When something fails here, and not in the private api tests, then there is
  # something wrong specifically in the methods handling the `current_reporter`
  # that needs to be fixed.
  def create_report(options = {}, &profiled_block)
    profiled_block ||= -> { default_block }
    MemoryProfiler.start(options)
    profiled_block.call rescue nil
    MemoryProfiler.stop
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

  def test_exception_handling
    # This overrides and skips exception handling from the base TestReporter
  end
end
