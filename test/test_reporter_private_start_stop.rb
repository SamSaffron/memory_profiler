# frozen_string_literal: true

require_relative 'test_reporter'

class TestReporterPrivateStartStop < TestReporter
  # This class extends TestReporter so it includes all of the tests from
  # TestReporter plus any additional test_* cases below and it
  # overrides create_report to use the start/stop methods

  # This specifically tests the private API of the start and stop methods of
  # the MemoryProfiler::Reporter class, and doesn't make use of the auto
  # instantiation of the class which is provided in the public API.
  #
  # This is meant to be a "base case" for the public API:  if things are
  # failing when testing the functionality of the public API, but not here,
  # then there is something wrong when handling the `current_report` variable
  # that needs to be addressed.
  def create_report(options={}, &profiled_block)
    profiled_block ||= -> { default_block }
    reporter = MemoryProfiler::Reporter.new(options)
    reporter.start
    profiled_block.call rescue nil
    reporter.stop
  end

  def test_exception_handling
    # This overrides and skips exception handling from the base TestReporter
  end
end
