# frozen_string_literal: true

require_relative 'test_helper'

class TestResults < Minitest::Test
  def test_pretty_print_works_with_no_args
    assert_output(/^Total allocated/, '') { MemoryProfiler::Results.new.pretty_print }
  end

  def test_pretty_print_works_with_io_arg
    io = StringIO.new
    assert_silent { MemoryProfiler::Results.new.pretty_print(io) }
    assert_match(/^Total allocated/, io.string)
  end

  def test_no_conflict_with_pretty_print
    require 'pp'
    assert_output(/#<MemoryProfiler::Results:\w*>/) { pp(MemoryProfiler::Results.new) }
  end
end
