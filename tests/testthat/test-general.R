testthat::test_that("general indexing works", {
    x <- c(-77.85641, -77.86663, -77.85641, -77.86358, -77.86372, -77.86627)
    y <- c(34.35935, 34.36440, 34.35936, 34.36328, 34.36336, 34.35290)
    extent <- c(xmax = 180, xmin = -180, ymax = 90, ymin = -90)

    for (e in seq_len(15)) {
        n <- 2^e
        test_xy       <- HILBERT_coords_to_xy_(n, x, y, extent)
        test_index    <- index(test_xy$x, test_xy$y, n = n)
        test_position <- HILBERT_position_(n, test_index)

        expect_equal(test_position, test_xy)
    }
})

testthat::test_that("lon/lat <--> row/col", {
    x <- c(-77.85641, -77.86663, -77.85641, -77.86358, -77.86372, -77.86627)
    y <- c(34.35935, 34.36440, 34.35936, 34.36328, 34.36336, 34.35290)
    extent <- c(xmax = 180, xmin = -180, ymax = 90, ymin = -90)

    for (e in 6:30) {
        n <- 2 ^ e
        test_xy     <- HILBERT_coords_to_xy_(n, x, y, extent)
        test_coords <- HILBERT_xy_to_coords_(n, test_xy$x, test_xy$y, extent)

        expect_equal(
            test_coords,
            data.frame(x = x, y = y),
            tolerance = 0.1
        )
    }
})