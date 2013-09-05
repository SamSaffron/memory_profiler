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
  end

  def test_top_n
    data = [7,1,2,2,3,3,99,3]
    results = MemoryProfiler::Reporter.top_n(data, 2)

    assert_equal([{data: 3, count: 3}, {data: 2, count: 2}], results)
  end

  def test_top_n_with_block
    data = [0,3,6,1,4,2]

    results = MemoryProfiler::Reporter.top_n(data,2) do |r|
      r%3
    end

    assert_equal([{data: 0, count: 3}, {data: 1, count: 2}], results)
  end
end
