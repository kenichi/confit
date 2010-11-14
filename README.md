Installation
------------
* sudo gem install confit

Initialization
--------------
* require 'confit'
* confit('path/to/config.yml')

Usage
-----
* puts confit.some_key # "The value of this key!"

Notes
-----
* Optional initialization params include environment and strict mode:
* confit('path/to/config.yml', 'development', true)
* Strict mode raises a NoMethodError if that key hasn't been loaded from your yaml file.