# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'memory_profiler/version'

Gem::Specification.new do |spec|
  spec.name          = "memory_profiler"
  spec.version       = MemoryProfiler::VERSION
  spec.authors       = ["Sam Saffron"]
  spec.email         = ["sam.saffron@gmail.com"]
  spec.description   = %q{Memory profiling routines for Ruby 3.1+}
  spec.summary       = %q{Memory profiling routines for Ruby 3.1+}
  spec.homepage      = "https://github.com/SamSaffron/memory_profiler"
  spec.license       = "MIT"

  spec.executables   = ["ruby-memory-profiler"]
  spec.files         = Dir["README.md", "CHANGELOG.md", "LICENSE.txt", "lib/**/*", "bin/ruby-memory-profiler"]

  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["changelog_uri"] = spec.homepage + "/blob/master/CHANGELOG.md"
end
