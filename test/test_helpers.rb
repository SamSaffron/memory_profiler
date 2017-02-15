require_relative 'test_helper'

class Foo; end
class BasicObjectSubclass < BasicObject ; end
class NilReportingClass
  def class
    # return nil when asked for the class
    nil
  end
end
class StringReportingClass
  def class
    # return a string when asked for the class
    'StringReportingClass'
  end
end
class NonStringNamedClass
  # return a symbol when the class is asked for the name
  def self.name
    :Symbol
  end
end


module MemoryProfiler

  class TestHelpers < Minitest::Test
    def assert_gem_parse(expected, path)
      helper = Helpers.new
      assert_equal(expected, helper.guess_gem(path))
    end

    def test_rubygems_parse
      assert_gem_parse( "rubygems",
                        "/home/sam/.rbenv/versions/ruby-head/lib/ruby/2.1.0/rubygems/version.rb")
    end

    def test_standard_parse
      assert_gem_parse( "rails_multisite",
                        "/home/sam/Source/discourse/vendor/gems/rails_multisite/lib")
    end

    def test_another_standard_parse
      assert_gem_parse( "activesupport-3.2.12",
                        "/home/sam/.rbenv/versions/ruby-head/lib/ruby/gems/2.1.0/gems/activesupport-3.2.12/lib/active_support/dependencies.rb")
    end

    def test_app_path_parse
      assert_gem_parse( "discourse/app",
                        "/home/sam/Source/discourse/app/assets")
    end

  end

end
