testthat::test_that("general indexing works", {
    x <- c(-77.85641, -77.86663, -77.85641, -77.86358, -77.86372, -77.86627)
    y <- c(34.35935, 34.36440, 34.35936, 34.36328, 34.36336, 34.35290)
    extent <- c(xmax = 180, xmin = -180, ymax = 90, ymin = -90)

    for (n in seq_len(15)) {
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

    for (n in 6:30) {
        test_xy     <- coords_to_position(x, y, n = n, extent = extent)
        test_coords <- position_to_coords(test_xy$x, test_xy$y, n = n, extent = extent)

        expect_equal(
            test_coords,
            data.frame(x = x, y = y),
            tolerance = 0.1
        )
    }
})