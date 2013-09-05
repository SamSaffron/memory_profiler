class MemoryProfiler::Results

  attr_accessor :total_allocated
  attr_accessor :total_retained

  attr_accessor :retained_by_gem
  attr_accessor :allocated_by_gem

  attr_accessor :retained_by_file
  attr_accessor :allocated_by_file

  attr_accessor :retained_by_location
  attr_accessor :allocated_by_location

  def pretty_print
    puts "Total allocated #{total_allocated}"
    puts "Total retained #{total_retained}"
    puts
    dump "Allocated by file", allocated_by_file
    dump "Retained by file", retained_by_file
    dump "Allocated by location", allocated_by_location
    dump "Retained by location", retained_by_location
  end

  def dump(description, data)
    puts description
    puts "-----------------------------------"
    data.each do |item|
      puts "#{item[:data]} x #{item[:count]}"
    end
    puts
  end
end
