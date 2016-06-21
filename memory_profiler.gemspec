# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'memory_profiler/version'

Gem::Specification.new do |spec|
  spec.name          = "memory_profiler"
  spec.version       = MemoryProfiler::VERSION
  spec.authors       = ["Sam Saffron"]
  spec.email         = ["sam.saffron@gmail.com"]
  spec.description   = %q{Memory profiling routines for Ruby 2.1+}
  spec.summary       = %q{Memory profiling routines for Ruby 2.1+}
  spec.homepage      = "https://github.com/SamSaffron/memory_profiler"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/*"]

  spec.required_ruby_version = ">= 2.1.0"
end
