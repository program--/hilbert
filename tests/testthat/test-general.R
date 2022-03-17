testthat::test_that("basic index @ n = 1", {
    expect_equal(hilbert::index(0, 0, n = 1L), 0)
    expect_equal(hilbert::index(0, 1, n = 1L), 1)
    expect_equal(hilbert::index(1, 1, n = 1L), 2)
    expect_equal(hilbert::index(1, 0, n = 1L), 3)
})

testthat::test_that("basic index @ n = 2", {
    expect_equal(hilbert::index(0, 0, n = 2L), 0)
    expect_equal(hilbert::index(0, 1, n = 2L), 3)
    expect_equal(hilbert::index(0, 2, n = 2L), 4)
    expect_equal(hilbert::index(0, 3, n = 2L), 5)

    expect_equal(hilbert::index(1, 0, n = 2L), 1)
    expect_equal(hilbert::index(1, 1, n = 2L), 2)
    expect_equal(hilbert::index(1, 2, n = 2L), 7)
    expect_equal(hilbert::index(1, 3, n = 2L), 6)

    expect_equal(hilbert::index(2, 0, n = 2L), 14)
    expect_equal(hilbert::index(2, 1, n = 2L), 13)
    expect_equal(hilbert::index(2, 2, n = 2L), 8)
    expect_equal(hilbert::index(2, 3, n = 2L), 9)

    expect_equal(hilbert::index(3, 0, n = 2L), 15)
    expect_equal(hilbert::index(3, 1, n = 2L), 12)
    expect_equal(hilbert::index(3, 2, n = 2L), 11)
    expect_equal(hilbert::index(3, 3, n = 2L), 10)
})

testthat::test_that("general indexing works", {
    x <- c(-77.85641, -77.86663, -77.85641, -77.86358, -77.86372, -77.86627)
    y <- c(34.35935, 34.36440, 34.35936, 34.36328, 34.36336, 34.35290)
    extent <- c(xmax = 180, xmin = -180, ymax = 90, ymin = -90)
    end <- 15
    if (requireNamespace("bit64", quietly = TRUE)) end <- 31

    for (n in seq_len(end)) {
        test_xy       <- coords_to_position(x, y, n = n, extent = extent)
        test_index    <- index(test_xy$x, test_xy$y, n = n)
        test_position <- position(test_index, n = n)

        expect_equal(test_position, test_xy)
    }
})

testthat::test_that("lon/lat <--> row/col", {
    x <- c(-77.85641, -77.86663, -77.85641, -77.86358, -77.86372, -77.86627)
    y <- c(34.35935, 34.36440, 34.35936, 34.36328, 34.36336, 34.35290)
    extent <- c(xmax = 180, xmin = -180, ymax = 90, ymin = -90)
    end <- 15
    if (requireNamespace("bit64", quietly = TRUE)) end <- 31

    for (n in 6:end) {
        test_xy     <- coords_to_position(x, y, n = n, extent = extent)
        test_coords <- position_to_coords(
            test_xy$x,
            test_xy$y,
            n = n,
            extent = extent
        )

        expect_equal(
            test_coords,
            data.frame(x = x, y = y),
            tolerance = 0.1
        )
    }
})