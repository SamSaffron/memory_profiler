require 'test_helper'

class TestReporter < Minitest::Test
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

end
