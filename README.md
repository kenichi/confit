**N.B. Confit 1.0 breaks backwards-compatibility with earlier versions!**

Installation
------------
* sudo gem install confit

Initialization
--------------
* `require 'confit'`
`confit('path/to/file_name.yml')`

Usage
-----
* `puts confit.file_name.some_key # "The value of this key!"`

Notes
-----
* Optional initialization params include environment, strict mode, and force reload of file
* `confit('path/to/file_name.yml', 'development', true, true) # confit.file_name.key_name -- from the yaml block named "development"`
* Strict mode raises a `MissingVariableError` if that key hasn't been loaded from your yaml file.
* Force reload ensures that the file is processed, even if Confit has already seen it before. This is useful for loading multiple 
environments at different times from within one file. 