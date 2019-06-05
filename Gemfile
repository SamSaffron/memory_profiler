# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in memory_profiler.gemspec
gemspec

group :development, :test do
  gem 'rake', require: false
  gem 'minitest', require: false
  gem 'guard', platforms: [:mri_22, :mri_23]
  gem 'guard-minitest', platforms: [:mri_22, :mri_23]
  gem 'longhorn', path: 'test/fixtures/gems/longhorn-0.1.0'
end
