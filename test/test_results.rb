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

  def scale_bytes_result
    MemoryProfiler.report { 1000.times { Array['a'..'z'][Array(0..25).sample] } }
  end

  def verify_unscaled_result(result, io)
    total_size = result.total_allocated_memsize
    array_size = result.allocated_memory_by_class.detect { |h| h[:data] == 'Array' }[:count]
    assert_match(/^Total allocated: #{total_size} bytes/, io.string, 'The total allocated memsize is unscaled.')
    assert_match(/^ +#{array_size}  Array$/, io.string, 'The allocated memsize for Array is unscaled.')
  end

  def test_scale_bytes_default
    result = scale_bytes_result
    io = StringIO.new
    result.pretty_print(io)
    verify_unscaled_result result, io
  end

  def test_scale_bytes_off
    result = scale_bytes_result
    io = StringIO.new
    result.pretty_print(io, scale_bytes: false)
    verify_unscaled_result result, io
  end

  def test_scale_bytes_true
    result = scale_bytes_result
    total_size = result.total_allocated_memsize / 1000.0
    array_size = result.allocated_memory_by_class.detect { |h| h[:data] == 'Array' }[:count] / 1000.0
    io = StringIO.new
    result.pretty_print(io, scale_bytes: true)

    assert_match(/^Total allocated: #{total_size.round(2)} kB/, io.string, 'The total allocated memsize is scaled.')
    assert_match(/^ +#{array_size.round(2)} kB  Array$/, io.string, 'The allocated memsize for Array is scaled.')
  end
end
