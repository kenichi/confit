require File.join(File.expand_path(File.join(File.dirname(__FILE__))), '..', 'lib', 'confit')

require 'test/unit'
require 'yaml'

class ConfitTest < Test::Unit::TestCase

  @@simple = File.join(File.expand_path(File.join(File.dirname(__FILE__))), 'simple.yml')
  @@complex = File.join(File.expand_path(File.join(File.dirname(__FILE__))), 'complex.yml')

  def setup
    Confit.reset!
  end

  def test_missing
    Confit::confit(@@simple, 'dev', :strict => true)
    puts "Doesn't exist: #{Confit::confit.test.your_mom}"
  rescue MissingVariableError => e
    assert_equal(e.class.to_s, "MissingVariableError")
  end

  def test_simple
    Confit::confit(@@simple, 'dev', :strict => true)
    assert_equal("Poeks", Confit::confit.simple.author)
  end

  def test_complex
    Confit::confit(@@complex, nil, :strict => true)
    assert_equal("the value", Confit::confit.complex.poeks_dev.a_hash.value)
  end

  def test_force
    Confit::confit(@@complex, 'jo_dev', :strict => true, :force => true)
    assert_equal("jo dev", Confit::confit.complex.app_name)
    Confit::confit(@@complex, 'poeks_dev', :strict => true, :force => true)
    assert_equal("poeks dev", Confit::confit.complex.app_name)
  end

  def test_key_with_spaces
    Confit::confit(@@simple, 'dev', :strict => true)
    assert_equal "Now underscores", Confit::confit.simple.a_key_with_spaces
  end

  def test_nesting
    Confit::confit(@@complex, 'foo', 'bar', :strict => false)
    assert_equal 1, Confit::confit.complex.num
    assert_equal false, Confit::confit.complex.boo
    Confit::confit(@@complex, 'foo', 'baz', :force => true)
    assert_equal 2, Confit::confit.complex.num
    assert_equal true, Confit::confit.complex.boo
  end

  def test_block
    Confit::confit @@complex, 'foo', 'bar', :strict => false do |pre_parse_hash|
      pre_parse_hash['boo_is_false'] = !pre_parse_hash['boo']
    end
    assert Confit::confit.complex.boo_is_false
    Confit::confit @@complex, 'foo', 'baz', :force => true do |pre_parse_hash|
      pre_parse_hash['boo_is_false'] = !pre_parse_hash['boo']
    end
    assert !Confit::confit.complex.boo_is_false
  end

end
