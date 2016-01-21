#!/usr/bin/ruby

$LOAD_PATH << '..'
$LOAD_PATH << '.'

require "redian"
require "server/redian_server"
require "server/redian_xss_filter"
require "test/unit"

class TestRedianXssFilter < Test::Unit::TestCase

  TEST_REDIAN_XSS_FILTER_NOT_ALLOWED = ["#{Redian::Server::XssFilter::DEFAULT_ALLOWED_PATTERN}", "some prefix #{Redian::Server::XssFilter::DEFAULT_ALLOWED_PATTERN}", "#{Redian::Server::XssFilter::DEFAULT_ALLOWED_PATTERN} some suffix"]
  
  @xss_filter = nil
  
  def setup

    @xss_filter = Redian::Server::XssFilter.with_defaults
    
  end
  
  def test_substitution

    TEST_REDIAN_XSS_FILTER_NOT_ALLOWED.each do |str|

      assert_raise(ArgumentError) { @xss_filter.check(str) }
      
    end
    
  end
  
end
