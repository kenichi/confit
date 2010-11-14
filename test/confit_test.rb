require File.join(File.expand_path(File.join(File.dirname(__FILE__))), '..', 'lib', 'confit')

require 'test/unit'
require 'rubygems'

class ConfitTest < Test::Unit::TestCase
  
  def _init
    file = File.join(File.expand_path(File.join(File.dirname(__FILE__))), '..', 'test', 'test.yml')
    confit(file, 'dev', true)
  end
  
  def test_main_methods
    _init
    assert_equal("twitterpoeks@gmail.com", confit.email)
  end

  def test_missing
    _init
    puts "Doesn't exist: #{confit.your_mom}"
  rescue NoMethodError => e
    puts "Rescued NoMethodError for confit.your_mom!"
  end
  
  def test_spacey
    _init
    assert_equal(confit.a_key_with_spaces, "Now underscores")
  end
  
end
