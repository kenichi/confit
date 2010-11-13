Installation
------------
gem build confit.gemspec
sudo gem install confit-0.0.1.gem

Initialization
--------------
require 'confit'
include Confit
confit('path/to/config.yml')

Usage
-----
puts confit.database # your_db.db

Notes
-----
Optional initialization params include environment and verbose:
confit('path/to/config.yml', 'development', true)
Verbose mode raises a NoMethodError if that key hasn't been loaded from your yaml file.