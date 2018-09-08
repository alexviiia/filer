
<!-- README.md is generated from README.Rmd. Please edit that file -->

# filer

The `filer` R package provides functions for easily constructing paths
and querying for files that may or may not be compressed (with .gz
extension).

## Installation

You can install filer from [GitHub](https://github.com/alexviiia/) using
the R commands:

``` r
library(devtools)
install_github("alexviiia/filer")
```

## Example

The default mode of `filer` is to construct file path strings:

``` r
# load package
library(filer)

# a file with standard .txt extension:
filer('myfile')
#> [1] "myfile.txt"

# change extension
filer('myfile', 'pdf')
#> [1] "myfile.pdf"

# no extension
filer('myfile', '')
#> [1] "myfile"

# compressed version
filer('myfile', gzip=TRUE)
#> [1] "myfile.txt.gz"

# compressed and different extension
filer('myfile', 'yml', gzip=TRUE)
#> [1] "myfile.yml.gz"

# compressed but no other extension
filer('myfile', '', gzip=TRUE)
#> [1] "myfile.gz"

# no special treatment for periods in name (not assumed to be existing extensions)
filer('myfile.blah')
#> [1] "myfile.blah.txt"
filer('myfile.blah', '')
#> [1] "myfile.blah"
```

There are two modes that make this much more useful in practice. Both of
these test for file existence, looking for compressed files when the
regular versions don’t exist, and let you know when neither files are
found.

Let’s quickly create a temporary file that really exists, so you can see
what happens when you test for it.

``` r
# "base" of file to test for (without extensions)
base <- file.path( tempdir(), 'myfile')
# full path of file, with standard plus compressed extension
fileTmp <- paste0(base, '.txt.gz')
# create file for this example
file.create(fileTmp)
#> [1] TRUE
```

The first mode is the “logical” mode, which returns a boolean for
whether a file exists. Note that if we’re testing for `file.txt`, this
function returns `TRUE` if either `file.txt` or `file.txt.gz` exist, and
`FALSE` only if both are missing.

``` r
# this file 'fakeFile.txt' doesn't exist
filer('fakeFile', logical=TRUE)
#> [1] FALSE

# test for file that does exist (exclude extensions).
# Although base.txt doesn't exist, compressed version base.txt.gz does, so this returns TRUE!
filer(base, logical=TRUE)
#> [1] TRUE
```

The second mode is the “exists” mode, which returns either the
uncompressed or compressed file path if it exists, but stops with an
informative error message if the file does not exist. This is very
useful when we want to load a file, we’re not sure if it was compressed
or not, but definitely want things to stop if the file cannot be found
(in either of uncompressed or compressed versions).

``` r
# this file 'fakeFile.txt' doesn't exist
filer('fakeFile', exists=TRUE)
#> Error in filer("fakeFile", exists = TRUE): Fatal in filer: could not find "fakeFile.txt" or its gzip version!

# test for file that does exist (exclude extensions).
# Although base.txt doesn't exist, compressed version base.txt.gz does (returns this version)
filer(base, exists=TRUE)
#> [1] "/tmp/RtmpimIl6F/myfile.txt.gz"
```

Lastly, let’s cleanup your file system.

``` r
# remove temporary file
file.remove(fileTmp)
#> [1] TRUE
```
