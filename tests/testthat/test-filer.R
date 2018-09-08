context("test-filer")

test_that("path constructor works (no existence tests)", {
    # run through all my examples in documentation

    # cases without compression extension
    expect_equal( filer('myfile'), "myfile.txt")
    expect_equal( filer('myfile', 'pdf'), "myfile.pdf")
    expect_equal( filer('myfile', ''), "myfile")

    # cases with compression extension
    expect_equal( filer('myfile', gzip=TRUE), "myfile.txt.gz")
    expect_equal( filer('myfile', 'yml', gzip=TRUE), "myfile.yml.gz")
    expect_equal( filer('myfile', '', gzip=TRUE), "myfile.gz")
    
    # no special treatment for periods in name (not assumed to be existing extensions)
    expect_equal( filer('myfile.blah'), "myfile.blah.txt")
    expect_equal( filer('myfile.blah', ''), "myfile.blah")
})

test_that("logical existence tests work (uncompressed case)", {

    # create a temporary file!
    # NOTE tempdir() already exists!
    nameE <- 'exists'
    nameN <- 'doesNotExist'
    nameE <- file.path( tempdir(), nameE) # add root dir for this to work
    nameN <- file.path( tempdir(), nameN) # add root dir for this to work
    fileE <- paste0(nameE, '.txt')
    fileN <- paste0(nameN, '.txt')
    file.create(fileE) # only create this one
    
    # this tests logicals...
    # look for these files directly
    expect_true( filer(nameE, logical=TRUE) )
    expect_false( filer(nameN, logical=TRUE) )
    # redundant extensions
    expect_true( filer(nameE, 'txt', logical=TRUE) )
    expect_false( filer(nameN, 'txt', logical=TRUE) )
    # mess up extensions
    expect_false( filer(nameE, 'yml', logical=TRUE) )
    expect_false( filer(nameN, 'yml', logical=TRUE) )
    # add gzip
    expect_false( filer(nameE, gzip=TRUE, logical=TRUE) )
    expect_false( filer(nameN, gzip=TRUE, logical=TRUE) )
    # add gzip, wrong extensions
    expect_false( filer(nameE, 'yml', gzip=TRUE, logical=TRUE) )
    expect_false( filer(nameN, 'yml', gzip=TRUE, logical=TRUE) )

    # as a precaution, remove temporary files right away
    file.remove(fileE)
})

test_that("logical existence tests work (compressed case)", {

    # create a temporary file!  Only create positive case here (negative cases were already looked at earlier)
    # NOTE tempdir() already exists!
    nameE <- 'existsGz'
    nameE <- file.path( tempdir(), nameE) # add root dir for this to work
    fileE <- paste0(nameE, '.txt.gz')
    file.create(fileE) # only create compressed version!
    
    # this tests logicals...
    # look for these files directly
    expect_true( filer(nameE, logical=TRUE) )
    # redundant extensions
    expect_true( filer(nameE, 'txt', logical=TRUE) )
    # add gzip
    expect_true( filer(nameE, gzip=TRUE, logical=TRUE) )
    # add gzip, redundant extensions
    expect_true( filer(nameE, 'txt', gzip=TRUE, logical=TRUE) )
    # mess up extensions
    expect_false( filer(nameE, 'yml', logical=TRUE) )
    # add gzip, wrong extensions
    expect_false( filer(nameE, 'yml', gzip=TRUE, logical=TRUE) )

    # as a precaution, remove temporary files right away
    file.remove(fileE)
})

test_that("fatal/non-logical existence tests work (uncompressed case)", {

    # create a temporary file!
    # NOTE tempdir() already exists!
    nameE <- 'exists2'
    nameN <- 'doesNotExist2'
    nameE <- file.path( tempdir(), nameE) # add root dir for this to work
    nameN <- file.path( tempdir(), nameN) # add root dir for this to work
    fileE <- paste0(nameE, '.txt')
    file.create(fileE) # only create this one
    
    # look for these files directly
    expect_equal( filer(nameE, exists=TRUE), fileE )
    expect_error( filer(nameN, exists=TRUE) )
    # redundant extensions
    expect_equal( filer(nameE, 'txt', exists=TRUE), fileE )
    expect_error( filer(nameN, 'txt', exists=TRUE) )
    # mess up extensions
    expect_error( filer(nameE, 'yml', exists=TRUE) )
    expect_error( filer(nameN, 'yml', exists=TRUE) )
    # add gzip
    expect_error( filer(nameE, gzip=TRUE, exists=TRUE) )
    expect_error( filer(nameN, gzip=TRUE, exists=TRUE) )
    # add gzip, wrong extensions
    expect_error( filer(nameE, 'yml', gzip=TRUE, exists=TRUE) )
    expect_error( filer(nameN, 'yml', gzip=TRUE, exists=TRUE) )

    # as a precaution, remove temporary files right away
    file.remove(fileE)
})

test_that("fatal/non-logical existence tests work (compressed case)", {

    # create a temporary file! (Only create positive case here (negative cases were already looked at earlier)
    # NOTE tempdir() already exists!
    nameE <- 'existsGz'
    nameE <- file.path( tempdir(), nameE) # add root dir for this to work
    fileE <- paste0(nameE, '.txt.gz')
    file.create(fileE) # only create compressed version
    
    # look for these files directly
    expect_equal( filer(nameE, exists=TRUE), fileE )
    # redundant extensions
    expect_equal( filer(nameE, 'txt', exists=TRUE), fileE )
    # mess up extensions
    expect_error( filer(nameE, 'yml', exists=TRUE) )
    # add gzip
    expect_equal( filer(nameE, gzip=TRUE, exists=TRUE), fileE )
    # add gzip, wrong extensions
    expect_error( filer(nameE, 'yml', gzip=TRUE, exists=TRUE) )
    
    # as a precaution, remove temporary files right away
    file.remove(fileE)
})

