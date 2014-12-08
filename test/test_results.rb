require_relative 'test_helper'

class TestResults < Minitest::Test
  def test_pretty_print_works
    io = StringIO.new
    MemoryProfiler::Results.new.pretty_print io
  end

  def test_no_color_output
    io = StringIO.new
    MemoryProfiler::Results.new.pretty_print io
  end

  def test_no_color_output
    io = StringIO.new
    MemoryProfiler::Results.new(color_output: true).pretty_print io
  end

end
gs