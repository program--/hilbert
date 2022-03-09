#' @title
#' Get index positions from a Hilbert Curve
#' @param h
#' One of: Integer vector, `data.frame`, or `matrix`.
#' @param ... Unused.
#' @param n
#' Exponent to the dimensions of the underlying grid. The Hilbert
#' Curve indices are based on a `2^n x 2^n` grid. This number
#' must be less than 15 due to the 32-bit implementation of R. This *must*
#' be the same as the `n` used in `index`.
#' @param idx
#' Column name or index containing the Hilbert Curve indices.
#' @param attach
#' If `TRUE`, adds the position as new columns to the given
#' `data.frame`/`matrix`. If `h` is a `data.frame`, then the
#' columns are named `x` and `y`; otherwise, it is two unnamed columns at
#' the end of the matrix.
#' @seealso index
#' @rdname position
#' @export
position <- function(h, ..., n = 10L) {
    UseMethod("position")
}

#' @rdname position
#' @export
position.data.frame <- function(h, ..., idx = 1, n = 10L, attach = TRUE) {
    positions <- HILBERT_position_(n, h[[idx[1]]])

    if (attach) {
        h$x <- positions$x
        h$y <- positions$y
        return(h)
    }

    positions
}

#' @rdname position
#' @export
position.matrix <- function(h, ..., idx = 1, n = 10L, attach = TRUE) {
    positions <- HILBERT_position_(n, h[[idx[1]]])

    if (attach) {
        h[[ncol(h) + 1]] <- positions$x
        h[[ncol(h) + 1]] <- positions$y
        return(h)
    }

    positions
}

#' @rdname position
#' @export
position.numeric <- function(h, ..., n = 10L) {
    h <- as.integer(h)
    NextMethod("position", h, ..., n = n)
}


#' @rdname position
#' @export
position.integer <- function(h, ..., n = 10L) {
    HILBERT_position_(n, h)
}