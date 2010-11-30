require File.join(File.expand_path(File.join(File.dirname(__FILE__))), '..', 'lib', 'confit')

require 'test/unit'

class ConfitTest < Test::Unit::TestCase

  def test_missing
    file = File.join(File.expand_path(File.join(File.dirname(__FILE__))), '..', 'test', 'simple.yml')
    confit(file, 'dev', true)
    puts "Doesn't exist: #{confit.test.your_mom}"
  rescue MissingVariableError => e
    assert_equal(e.class.to_s, "MissingVariableError")
  end
  
  def test_simple
    file = File.join(File.expand_path(File.join(File.dirname(__FILE__))), '..', 'test', 'simple.yml')
    confit(file, 'dev', true)
    assert_equal("Poeks", confit.simple.author)
  end

  def test_complex
    file = File.join(File.expand_path(File.join(File.dirname(__FILE__))), '..', 'test', 'complex.yml')
    confit(file, nil, true)
    assert_equal("the value", confit.complex.poeks_dev.a_hash.value)
  end
  
  def test_force
    file = File.join(File.expand_path(File.join(File.dirname(__FILE__))), '..', 'test', 'complex.yml')
    confit(file, 'jo_dev', true, true)
    assert_equal("jo dev", confit.complex.app_name)
    confit(file, 'poeks_dev', true, true)
    assert_equal("poeks dev", confit.complex.app_name)
  end
  
end
