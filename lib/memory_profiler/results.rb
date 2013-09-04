class MemoryProfiler::Results

  attr_accessor :total_allocated
  attr_accessor :total_retained

  attr_accessor :retained_by_gem
  attr_accessor :allocated_by_gem

  attr_accessor :retained_by_file
  attr_accessor :allocated_by_file

  attr_accessor :retained_by_location
  attr_accessor :allocated_by_location
end
