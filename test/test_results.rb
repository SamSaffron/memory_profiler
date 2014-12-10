require_relative 'test_helper'

class TestResults < Minitest::Test
  def test_pretty_print_works
    io = StringIO.new
    MemoryProfiler::Results.new.pretty_print io
  end

end