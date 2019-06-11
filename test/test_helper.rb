# frozen_string_literal: true

require 'memory_profiler'
require 'minitest/pride'
require 'minitest/autorun'
require_relative 'test_helpers'

FIXTURE_DIR = File.expand_path('fixtures', __dir__).freeze

def require_fixture_gem(name)
  lib_path = File.join(FIXTURE_DIR, 'gems', "#{name}-0.1.0", 'lib')
  $LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)
  require name
end
