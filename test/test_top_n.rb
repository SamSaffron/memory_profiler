# frozen_string_literal: true

require_relative 'test_helper'

class HashWithTopN < Hash
  include MemoryProfiler::TopN
end

class TestTopN < Minitest::Test

  TestItem = Struct.new(:metric1, :metric2, :memsize)

  def sample_data
    HashWithTopN.new.merge!(
        {
            1 => TestItem.new('class1', 'gem1', 100),
            2 => TestItem.new('class1', 'gem2', 100),
            3 => TestItem.new('class1', 'gem3', 100),
            4 => TestItem.new('class2', 'gem1', 100),
            5 => TestItem.new('class2', 'gem1', 100),
            6 => TestItem.new('class2', 'gem1', 100),
            7 => TestItem.new('class3', 'gem2', 1000)
        }
    )
  end

  def test_top_n_small_n
    data = sample_data
    metric1_results = data.top_n(2, :metric1)
    metric2_results = data.top_n(2, :metric2)

    assert_equal([[{:data=>"class3", :count=>1000}, {:data=>"class1", :count=>300}],
                  [{:data=>"class1", :count=>3}, {:data=>"class2", :count=>3}]],
                 metric1_results)

    assert_equal([[{:data=>"gem2", :count=>1100}, {:data=>"gem1", :count=>400}],
                  [{:data=>"gem1", :count=>4}, {:data=>"gem2", :count=>2}]],
                 metric2_results)
  end

  def test_top_n_large_n
    data = sample_data
    metric1_results = data.top_n(50, :metric1)
    metric2_results = data.top_n(50, :metric2)

    assert_equal([[{:data=>"class3", :count=>1000}, {:data=>"class1", :count=>300}, {:data=>"class2", :count=>300}],
                  [{:data=>"class1", :count=>3}, {:data=>"class2", :count=>3}, {:data=>"class3", :count=>1}]],
                 metric1_results)

    assert_equal([[{:data=>"gem2", :count=>1100}, {:data=>"gem1", :count=>400}, {:data=>"gem3", :count=>100}],
                  [{:data=>"gem1", :count=>4}, {:data=>"gem2", :count=>2}, {:data=>"gem3", :count=>1}]],
                 metric2_results)
  end

end
