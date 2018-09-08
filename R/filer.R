#' Get file path transparently for a possibly-gzip-compressed file, with lots of useful checks
#'
#' Returns a (relative but otherwise complete) file path from its base name and optional extensions (default .txt).
#' The main goal is to handle compressed files transparently, without having to know ahead of time if the compressed or uncompressed version is the one that is present.
#' If \code{gzip=TRUE}, .gz extension gets added.
#' If \code{exists=TRUE}, existing uncompressed or compressed file path is returned, or stops if file is missing.
#' If \code{logical=TRUE}, returns a boolean that indicates if file exists or not, testing both uncompressed and compressed versions.
#'
#' Behavior when multiple modifiers are \code{TRUE}:
#' \code{logical=TRUE} overrides \code{exists=TRUE} (returns boolean, non-fatal).
#' \code{gzip=TRUE} restricts file existence test to compressed file when either \code{logical=TRUE} or \code{exists=TRUE}.
#'
#' @param name Base name of file (mandatory).
#' @param ext Extension (default txt).  Period between \code{name} and \code{ext} gets added automatically unless \code{ext==''}.
#' @param gzip If true, adds .gz extension after usual extension.
#' @param exists If true, checks that file exists; if file did not exist, checks if compressed version exists (returns that path in that case).  If \code{gzip=TRUE}, then only the compressed version is checked for existence.
#' @param logical If true, function will return a boolean for whether file exists or not (regular or compressed).
#'
#' @return
#' If \code{exists=FALSE} and \code{logical=FALSE}, returns the desired relative file path, with extensions added as requested (no existence tests).
#' If \code{exists=TRUE}, returns the path of the file that exists (adds .gz extension if only that file exists, even if \code{gzip=FALSE}), stopping (fatally) if the file is missing.
#' If \code{logical=TRUE}, returns \code{TRUE} if file (regular or compressed) exists, \code{FALSE} otherwise.
#'
#' @examples
#' # examples that simply construct file path (without existence tests)
#' filer('myfile') # returns "myfile.txt"
#' filer('myfile', 'pdf') # returns "myfile.pdf"
#' filer('myfile', '') # returns "myfile" (no extension)
#' filer('myfile', gzip=TRUE) # returns "myfile.txt.gz"
#' filer('myfile', 'yml', gzip=TRUE) # returns "myfile.yml.gz"
#' filer('myfile', '', gzip=TRUE) # returns "myfile.gz"
#' # no special treatment for periods in name (not assumed to be existing extensions)
#' filer('myfile.blah') # returns "myfile.blah.txt"
#' filer('myfile.blah', '') # returns "myfile.blah" (no added extension)
#'
#' # test that file exists
#' # returns TRUE if myfile.txt or myfile.txt.gz exist, FALSE otherwise
#' filer('myfile', logical=TRUE)
#' # returns TRUE if myfile.txt.gz exist, FALSE otherwise (even if myfile.txt exists)
#' filer('myfile', gzip=TRUE, logical=TRUE)
#'
#' \dontrun{
#' ### (these examples are fatal when the file in question doesn't exist)
#' 
#' # returns myfile.txt if it exists,
#' # or myfile.txt.gz if that exist,
#' # or stops with an informative message if file does not exist
#' filer('myfile', exists=TRUE)
#' 
#' # returns myfile.txt.gz if it exist,
#' # or stops with an informative message if file does not exist
#' # (even if myfile.txt exists)
#' filer('myfile', gzip=TRUE, exists=TRUE)
#' }
#'
#' @export
filer <- function(name, ext='txt', gzip=FALSE, exists=FALSE, logical=FALSE) {
    ## return full path, with extension (but possibly missing compressed extension)
    ## if exists, looks for real file (compressed or not) and dies if it's not found unless logical is TRUE
    ## if logical, returns boolean for whether file exists or not! (doesn't die but runs thorough test for file existence)
    if (missing(name))
        stop('Fatal in filer: file name missing!')
    if (ext != '') {
        ## blank extensions means nothing is appended
        ## otherwise add a period before extension, all of which will be appended below
        ext <- paste0('.', ext)
    }
    fi <- paste0(name, ext)
    if (gzip) {
        # force to use gz extension (required for writing gz files, won't do automatically)
        fi <- paste0(fi, '.gz') # add compressed extension
    }
    if (exists || logical) { # trigger this behavior if we want the logical output too!
        # triggers search for either existing file or existing compressed file, dying if neither is present!
        if (!file.exists(fi)) {
            if (gzip) {
                # means we're already looking for a compressed version, so die without other tries (and give informative message)
                if (logical) {
                    return(FALSE)
                } else {
                    stop('Fatal in filer: could not find "', fi, '"!')
                }
            } else {
                # means we've only looked for regular (uncompressed) version
                fiGz <- paste0(fi, '.gz') # alternative path
                if (file.exists(fiGz)) {
                    fi <- fiGz # use the compressed version as the version to read
                } else {
                    if (logical) {
                        return(FALSE)
                    } else {
                        stop('Fatal in filer: could not find "', fi, '" or its gzip version!')
                    }
                }
            }
        }
    }
    if (logical) {
        return(TRUE)
    } else {
        return(fi) # this is what gets returned!
    }
}

