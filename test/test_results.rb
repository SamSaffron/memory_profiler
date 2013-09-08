require 'test_helper'

class TestResults < Minitest::Test
  def test_pretty_print_works
    MemoryProfiler::Results.new.pretty_print
  end
end
