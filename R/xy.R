#' @title
#' Convert Coordinates to Grid Positions
#' @param x
#' One of: Numeric vector, `data.frame`, or `matrix`.
#' If a numeric vector, then it corresponds to X coordinates.
#' @param y
#' Numeric vector corresponding to Y coordinates.
#' @param ... Unused.
#' @param extent
#' Named vector with names `xmax`, `xmin`, `ymax`, `ymin`.
#' Corresponds to the bounding box of the given coordinates.
#' If `extent` is `NULL`, then the bounding box is found from the
#' given coordinates.
#' @param n
#' Exponent to the dimensions of the underlying grid. The Hilbert
#' Curve indices are based on a `2^n x 2^n` grid. This number
#' must be less than 15 due to the 32-bit implementation of R.
#' @param coords
#' Column names or indices of a `data.frame`/`matrix` that
#' contain the coordinates.
#' @param attach
#' If `TRUE`, adds the position as new columns to the given
#' `data.frame`/`matrix`. This will *replace* the coordinate columns.
#' @rdname coords_to_position
#' @export
coords_to_position <- function(x, ..., extent = NULL, n = 10L) {
    UseMethod("coords_to_position")
}

#' @rdname coords_to_position
#' @export
coords_to_position.data.frame <- function(x, ..., coords = c(1, 2), extent = NULL, n = 10L, attach = TRUE) {
    if (is.null(extent)) {
        extent <- c(
            xmax = max(x[[coords[1]]]),
            xmin = min(x[[coords[1]]]),
            ymax = max(x[[coords[2]]]),
            ymin = min(x[[coords[2]]])
        )
    }

    positions <-
        HILBERT_coords_to_xy_(n, x[[coords[1]]], x[[coords[2]]], extent)

    if (attach) {
        x[[coords[1]]] <- positions$x
        x[[coords[2]]] <- positions$y
        return(x)
    }

    positions
}

#' @rdname coords_to_position
#' @export
coords_to_position.matrix <- function(x, ..., coords = c(1, 2), extent = NULL, n = 10L, attach = TRUE) {
    if (is.null(extent)) {
        extent <- c(
            xmax = max(x[[coords[1]]]),
            xmin = min(x[[coords[1]]]),
            ymax = max(x[[coords[2]]]),
            ymin = min(x[[coords[2]]])
        )
    }

    positions <-
        HILBERT_coords_to_xy_(n, x[[coords[1]]], x[[coords[2]]], extent)

    if (attach) {
        x[[coords[1]]] <- positions$x
        x[[coords[2]]] <- positions$y
        return(x)
    }

    positions
}

#' @rdname coords_to_position
#' @export
coords_to_position.numeric <- function(x, y, ..., extent = NULL, n = 10L) {
    if (is.null(extent)) {
        extent <- c(
            xmax = max(x),
            xmin = min(x),
            ymax = max(y),
            ymin = min(y)
        )
    }

    NextMethod("coords_to_position", x, ..., extent = extent, n = n)
}

#' @rdname coords_to_position
#' @export
coords_to_position.integer <- function(x, y, ..., extent = NULL, n = 10L) {
    HILBERT_coords_to_xy_(n, x, y, extent)
}

#' @rdname coords_to_position
#' @export
coords_to_position.double <- function(x, y, ..., extent = NULL, n = 10L) {
    HILBERT_coords_to_xy_(n, x, y, extent)
}

#' @title
#' Convert Grid Positions to Coordinates
#' @param x
#' One of: Integer vector, `data.frame`, or `matrix`.
#' If a numeric vector, then it corresponds to Row positions.
#' @param y
#' Integer vector corresponding to Column positions.
#' @param ... Unused.
#' @param extent
#' Named vector with names `xmax`, `xmin`, `ymax`, `ymin`.
#' Corresponds to the bounding box of the given coordinates.
#' If `extent` is `NULL`, then the function will throw an exception.
#' @param n
#' Exponent to the dimensions of the underlying grid. The Hilbert
#' Curve indices are based on a `2^n x 2^n` grid. This number
#' must be less than 15 due to the 32-bit implementation of R.
#' @param coords
#' Column names or indices of a `data.frame`/`matrix` that
#' contain the positions.
#' @param attach
#' If `TRUE`, adds the coordinates as new columns to the given
#' `data.frame`/`matrix`. This will *replace* the position columns.
#' @rdname coords_to_position
#' @export
position_to_coords <- function(x, ..., extent = NULL, n = 10L) {
    if (is.null(extent)) {
        stop("`extent` is required.")
    }
    UseMethod("position_to_coords")
}

#' @rdname coords_to_position
#' @export
position_to_coords.data.frame <- function(x, ..., coords = c(1, 2), extent = NULL, n = 10L, attach = TRUE) {
    coordinates <-
        HILBERT_xy_to_coords_(n, x[[coords[1]]], x[[coords[2]]], extent)

    if (attach) {
        x[[coords[1]]] <- coordinates$x
        x[[coords[2]]] <- coordinates$y
        return(x)
    }

    coordinates
}

#' @rdname coords_to_position
#' @export
position_to_coords.matrix <- function(x, ..., coords = c(1, 2), extent = NULL, n = 10L, attach = TRUE) {
    coordinates <-
        HILBERT_xy_to_coords_(n, x[[coords[1]]], x[[coords[2]]], extent)

    if (attach) {
        x[[coords[1]]] <- coordinates$x
        x[[coords[2]]] <- coordinates$y
        return(x)
    }

    coordinates
}

#' @rdname coords_to_position
#' @export
position_to_coords.numeric <- function(x, y, ..., extent = NULL, n = 10L) {
    HILBERT_xy_to_coords_(n, as.integer(x), as.integer(y), extent)
}

#' @rdname coords_to_position
#' @export
position_to_coords.integer <- function(x, y, ..., extent = NULL, n = 10L) {
    HILBERT_xy_to_coords_(n, x, y, extent)
}
