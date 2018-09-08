
<!-- README.md is generated from README.Rmd. Please edit that file -->

# filer

The `filer` R package provides functions for easily constructing paths
and querying for files that may or may not be compressed (with .gz
extension).

## Installation

You can install filer from [GitHub](https://github.com/OchoaLab/) using
the R commands:

``` r
library(devtools)
install_github("OchoaLab/filer")
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

First is the “logical” mode, which returns a boolean for whether a file
exists. Note that if we’re testing for `file.txt`, this function returns
`TRUE` if either `file.txt` or `file.txt.gz` exist, and `FALSE` only if
both are missing.

``` r
# this file 'myfile.txt' doesn't exist
filer('myfile', logical=TRUE)
#> [1] FALSE

# create a temporary file for this example
base <- file.path( tempdir(), 'myfile')
fileTmp <- paste0(base, '.txt')
file.create(fileTmp)
#> [1] TRUE
# test for file (exclude extension).  Since this really exists it'll return TRUE!
filer( base, logical=TRUE)
#> [1] TRUE
# remove file
file.remove(fileTmp)
#> [1] TRUE

# create another temporary file that has compressed extension
# reuse base
fileTmpGz <- paste0(base, '.txt.gz')
file.create(fileTmpGz)
#> [1] TRUE
# test for file (exclude extensions).  Since this really exists it'll return TRUE!
# filer finds compressed version even though we didn't say it'd be compressed
filer( base, logical=TRUE)
#> [1] TRUE
# remove file
file.remove(fileTmpGz)
#> [1] TRUE
```

The second is “exists” mode, which returns either the uncompressed or
compressed file path if it exists, but stops with an informative error
message if the file does not exist. This is very useful when we want to
load a file, we’re not sure if it was compressed or not, but definitely
want things to stop if the file cannot be found (in either of
uncompressed or compressed versions).

``` r
# this file 'myfile.txt' doesn't exist
filer('myfile', exists=TRUE)
```

<div class="alert alert-danger">

\#\> Error in filer(“myfile”, exists = TRUE): Fatal in filer: could not
find “myfile.txt” or its gzip version\!

</div>

``` r

# create temporary file with compressed extension
# reusing earlier base and fileTmpGz
file.create(fileTmpGz) # create again
#> [1] TRUE
# test for file (exclude extensions).
# Returns path of the file that exists (uncompressed if found, otherwise compressed if that is found)
# filer finds compressed version even though we didn't say it'd be compressed
filer( base, exists=TRUE)
#> [1] "/tmp/Rtmppm6TTr/myfile.txt.gz"
# remove file
file.remove(fileTmpGz)
#> [1] TRUE
```
