require File.join(File.expand_path(File.join(File.dirname(__FILE__))), '..', 'lib', 'confit')

require 'test/unit'
require 'rubygems'

include Confit

class ConfitTest < Test::Unit::TestCase
  
  def test_main_methods
    file = File.join(File.expand_path(File.join(File.dirname(__FILE__))), '..', 'test', 'test.yml')
    puts file
    confit(file, 'dev', true)
    
    assert_equal("twitterpoeks@gmail.com", confit.email)
  end

end
