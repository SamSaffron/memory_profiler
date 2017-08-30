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

  def test_string_report_with_regular_string_data
    allocated = MemoryProfiler::StatHash.new
    retained  = string_data
    results = MemoryProfiler::Results.new.register_results(allocated, retained, 50)

    expected = <<-OUTPUT.gsub(/^ {6}/, "")
      Retained String Report
      -----------------------------------
               3  "a"
               2  #{file1.join(":")}
               1  #{file2.join(":")}

               2  "b"
               1  #{file2.join(":")}
               1  #{file1.join(":")}

    OUTPUT

    io = StringIO.new
    assert_silent { results.pretty_print(io) }

    # Rewind as much as is in the retained string report
    io.seek(-expected.size, IO::SEEK_END)
    assert_equal(expected, io.read)
  end

  def test_string_report_with_md5_string_data
    allocated = MemoryProfiler::StatHash.new
    retained  = string_data(true)
    results = MemoryProfiler::Results.new.register_results(allocated, retained, 50)

    expected = <<-OUTPUT.gsub(/^ {6}/, "")
      Retained String Report
      -----------------------------------
               2  "a"
               1  #{file2.join(":")}
               1  #{file1.join(":")}

               2  "b"
               1  #{file2.join(":")}
               1  #{file1.join(":")}

               1  "a"
               1  #{file1.join(":")}

    OUTPUT

    io = StringIO.new
    assert_silent { results.pretty_print(io) }

    # Rewind as much as is in the retained string report
    io.seek(-expected.size, IO::SEEK_END)
    assert_equal(expected, io.read)
  end

  private

  def string_data(md5=false)
    stat = MemoryProfiler::Stat
    hash = MemoryProfiler::StatHash.new
    gem  = "memory-profiler-#{MemoryProfiler::VERSION}"

    hash[1] = stat.new("String", gem, file1[0], file1.join(":"), 10, "a", md5 && "1")
    hash[2] = stat.new("String", gem, file1[0], file1.join(":"), 10, "a", md5 && "2")
    hash[3] = stat.new("String", gem, file2[0], file2.join(":"), 10, "a", md5 && "1")
    hash[4] = stat.new("String", gem, file1[0], file1.join(":"), 20, "b", md5 && "3")
    hash[5] = stat.new("String", gem, file2[0], file2.join(":"), 20, "b", md5 && "3")

    hash
  end

  def file1
    @file1 ||= [ File.expand_path(__FILE__).to_s, 25 ]
  end

  def file2
    @file_1 ||= MemoryProfiler::Results.method(:register_type).source_location
  end
end
