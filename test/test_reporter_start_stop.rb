require_relative 'test_helper'
require_relative 'test_reporter'

class TestReporterStartStop < TestReporter

  def create_report(options={}, &yield_for_report_block)
    retained = []
    prof_block = report_block(retained, &yield_for_report_block)
    reporter = MemoryProfiler::Reporter.new(options)
    reporter.start
    prof_block.call
    reporter.stop
  end

end
