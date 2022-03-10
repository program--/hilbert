#' @title
#' Index positions to a Hilbert Curve
#' @param x
#' One of: Numeric vector, `data.frame`, or `matrix`.
#' If a numeric vector, then it corresponds to the rows
#' of a position.
#' @param ... Unused.
#' @param n
#' Exponent to the dimensions of the underlying grid. The Hilbert
#' Curve indices are based on a `2^n x 2^n` grid. This number
#' must be less than 15 due to the 32-bit implementation of R.
#' @param y
#' Numeric vector.
#' Corresponds to the columns of a position.
#' @param coords
#' Column names or indices of a `data.frame`/`matrix` that
#' contain the position coordinates.
#' @param attach
#' If `TRUE`, adds the indices as a new column to the given
#' `data.frame`/`matrix`. If `x` is a `data.frame`, then the
#' column is named `h`; otherwise, it is an unnamed column at
#' the end of the matrix.
#' @seealso position
#' @rdname index
#' @export
index <- function(x, ..., n = 10L) {
    if (n < 16L) {
        UseMethod("index")
    } else {
        if (!requireNamespace("bit64", quietly = TRUE)) {
            stop("`bit64` is required to use exponents greater than 15.")
        }

        UseMethod("index64")
    }
}

#' @rdname index
#' @export
index.data.frame <- function(x, ..., n, coords = c(1, 2), attach = TRUE) {
    indices <- HILBERT_index_(n, x[[coords[1]]], x[[coords[2]]])

    if (attach) {
        x$h <- indices
        return(x)
    }

    indices
}

#' @rdname index
#' @export
index.matrix <- function(x, ..., n, coords = c(1, 2), attach = TRUE) {
    indices <- HILBERT_index_(n, x[[coords[1]]], x[[coords[2]]])

    if (attach) {
        x[[ncol(x) + 1]] <- indices
        return(x)
    }

    indices
}

#' @rdname index
#' @export
index.double <- function(x, y, ..., n) {
    HILBERT_index_(n, as.integer(x), as.integer(y))
}

#' @rdname index
#' @export
index.integer <- function(x, y, ..., n) {
    HILBERT_index_(n, x, y)
}

#' @rdname index
#' @export
index.numeric <- function(x, y, ..., n) {
    HILBERT_index_(n, as.integer(x), as.integer(y))
}

#' @rdname index
#' @export
index64 <- function(x, ..., n = 10L) {
    UseMethod("index64")
}

#' @rdname index
#' @export
index64.data.frame <- function(x, ..., n, coords = c(1, 2), attach = TRUE) {
    indices <- bit64::as.integer64(
        HILBERT_index64_(n, x[[coords[1]]], x[[coords[2]]])
    )

    if (attach) {
        x$h <- indices
        return(x)
    }

    indices
}

#' @rdname index
#' @export
index64.matrix <- function(x, ..., n, coords = c(1, 2), attach = TRUE) {
    indices <- bit64::as.integer64(
        HILBERT_index64_(n, x[[coords[1]]], x[[coords[2]]])
    )

    if (attach) {
        x[[ncol(x) + 1]] <- indices
        return(x)
    }

    indices
}

#' @rdname index
#' @export
index64.double <- function(x, y, ..., n) {
    bit <- HILBERT_index64_(n, as.integer(x), as.integer(y))
    bit64::as.integer64(bit)
}

#' @rdname index
#' @export
index64.integer <- function(x, y, ..., n) {
    bit <- HILBERT_index64_(x, y, n = n)
    bit64::as.integer64(bit)
}

#' @rdname index
#' @export
index64.numeric <- function(x, y, ..., n) {
    bit <- HILBERT_index64_(x, y, n = n)
    bit64::as.integer64(bit)
}