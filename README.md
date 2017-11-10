# dtbook2sbsform

This project provides:

a command line tool to transform [dtbook xml source files][dtbook]
into a braille format proprietary to [SBS][] using [Saxon][] with a
[java extension][] that offers translating text into braille using
[liblouis][].

[dtbook]: http://en.wikipedia.org/wiki/DTBook
[SBS]: http://www.sbs.ch
[Saxon]: http://saxon.sourceforge.net/
[java extension]: https://github.com/sbsdev/LiblouisSaxonExtension
[liblouis]: http://liblouis.org

## Usage command line tools

    cd dtbook2sbsform
    ./dtbook2sbsform.sh dtbook.xml
    
calls `saxon.sh`, transforms `dtbook.xml` and performs line breaking
using `linebreak.sh` printing output onto stdout.

    ./saxon.sh
    
calls saxon, offering its rich command line interface, includes our
extension function (see `resources/xsl/dtbook2sbsform.xsl`).

    ./linebreak.sh
    
breaks lines according to sbs rules: only lines beginning with a blank
will be broken. Line width is 80 chars.

    ./utfx.sh
    
Performs [utfx](http://utf-x.sourceforge.net/) (svn version) tests.

## Prerequisite installs

* [java](http://java.sun.com)
  * Unfortunately this project is not compatible with Java 8. Please
    use Java 7 or lower.
* [liblouis](http://code.google.com/p/liblouis/)

## Testing

This project has been ported to support testing via xprocspec tests.
For legacy reasons however testing with `utfx` is still supported via
a Docker image.

``` console
docker build -t dtbook2sbsform -f Dockerfile.test_with_utfx .
```

To run the tests using above image simply run

``` console
docker run --rm --volume=$(pwd):/usr/src/dtbook2sbsform -t dtbook2sbsform
```

To run a single test file use the following command:

``` console
docker run --rm --volume=$(pwd):/usr/src/dtbook2sbsform -t dtbook2sbsform -Dutfx.test.file=test_xsl/11_most_frequent_bugs_test.xml
```

## Authors

### Christian Egli

+ https://github.com/egli

### Bernhard Wagner

+ http://xmlizer.net
+ http://github.com/bwagner

## License

Copyright 2011, 2015 SBS.

Licensed under GNU Lesser General Public License as published by the
Free Software Foundation, either
[version 3](http://www.gnu.org/licenses/gpl-3.0.html) of the License,
or (at your option) any later version.
