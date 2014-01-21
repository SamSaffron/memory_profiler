require_relative 'test_helper'

class ArrayWithTopN < Array
  include MemoryProfiler::TopN
end

class TestTopN < Minitest::Test

  def tn(*vals)
    ArrayWithTopN.new.concat(vals)
  end

  def test_top_n
    data = tn( 7,1,2,2,3,3,99,3 )
    results = data.top_n(2)

    assert_equal([{data: 3, count: 3}, {data: 2, count: 2}], results)
  end

  def test_top_n_with_block
    data = tn( 0,3,6,1,4,2 )

    results = data.top_n(2) do |r|
      r%3
    end

    assert_equal([{data: 0, count: 3}, {data: 1, count: 2}], results)
  end
  def test_top_n_with_block_and_size
    data = tn( [1,100], [1,10], [2,1], [2,1], [2,1],[3,100] )

    results = data.top_n(2) do |r|
      r
    end

    assert_equal([{data: 1, count: 110}, {data: 3, count: 100}], results)
  end

end
