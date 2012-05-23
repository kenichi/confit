Gem::Specification.new do |s|
  s.name        = "confit"
  s.version     = "1.1.0"
  s.authors     = ['Jen Oslislo', 'Kenichi Nakamura']
  s.email       = ["twitterpoeks@gmail.com, kenichi.nakamura@gmail.com"]
  s.homepage    = "https://github.com/poeks/confit"
  s.summary     = "A teeny, tiny configuration manager for YAML config files."
  s.description = "A teeny, tiny configuration manager for YAML config files."

  s.files        = Dir["{lib,test}/**/*"] + Dir["[A-Z]*"]
  s.require_path = "lib"

  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.6"
end
