
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hilbert

<!-- badges: start -->
<!-- badges: end -->

**hilbert** provides utilities for quick indexing/encoding of
coordinates to a Hilbert Curve.

## Installation

You can install **hilbert** via either `remotes` or `pak`:

``` r
# pak
pak::pkg_install("program--/hilbert")

# remotes
remotes::install_github("program--/hilbert")
```

## Example

### Setting Up

``` r
x <- -77.85641
y <- 34.35935
n <- 15
e <- c(xmax = 180, xmin = -180, ymax = 90, ymin = -90)
```

### Coordinates to Position

``` r
pos <- hilbert::coords_to_position(x, y, n = n, extent = e)
pos
#>       x     y
#> 1 23469 10128
```

### Position to Index

``` r
index <- hilbert::index(pos, coords = c("x", "y"), n = n, attach = TRUE)
index
#>       x     y         h
#> 1 23469 10128 936388435
```

### Index to Position

``` r
new_pos <- hilbert::position(index, idx = "h", n = n, attach = FALSE)
new_pos
#>       x     y
#> 1 23469 10128
```

### Position to Coordinates

``` r
new_xy <- hilbert::position_to_coords(new_pos, coords = c("x", "y"), extent = e, n = n, attach = TRUE)
new_xy
#>         x        y
#> 1 -77.846 34.36354
```

## Roadmap

-   [x] General indexing/retrieval
-   [ ] 64-bit Integer Support (via `bit64`)
    -   [x] `index()`
    -   [x] `position()`
    -   [ ] `coords_to_position()`
    -   [ ] `position_to_coords()`
-   [ ] Multiprecision Integer Support (via `bignum`)
    -   [ ] `index()`
    -   [ ] `position()`
    -   [ ] `coords_to_position()`
    -   [ ] `position_to_coords()`
