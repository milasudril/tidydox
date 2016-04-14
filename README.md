tidydox
=======

This is an attempty to generate better HTML output from Doxygen.

Installation
------------

    sudo make install

will copy resource files to `/usr/local/share/tidydox`

The script will be copied to `/usr/local/bin`.

If not root or not GNU/Linux, modify RESOURCEDIR in `tidydox.sh` so it points to
another location. Then copy the files to another location.


Usage
-----

Run

    tidydox

in the project directory. See also `index.xml` and `docparams.xml` for
configuration options. These two files has to exist in the project root
directory. Recursive scan is off in Doxyfile.
