Installation
------------
* sudo gem install confit

Initialization
--------------
* require 'confit'
* include Confit
* confit('path/to/config.yml')

Usage
-----
* puts confit.database # your_db.db

Notes
-----
* Optional initialization params include environment and verbose:
* confit('path/to/config.yml', 'development', true)
* Verbose mode raises a NoMethodError if that key hasn't been loaded from your yaml file.