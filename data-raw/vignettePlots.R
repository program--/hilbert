library(sf)
library(ggplot2)
library(ggspatial)

data("quakes")
quakes    <- quakes[quakes$long < 179.5, ]
quakes_sf <- sf::st_as_sf(quakes, coords = c("long", "lat"), crs = 4326)
quakes_bb <- c(xmin = 160, ymin = -40, xmax = 180, ymax = -10)
class(quakes_bb) <- "bbox"
quakes_bb <- sf::st_as_sfc(quakes_bb) |>
             sf::st_set_crs(4326)

# Dataset Visual
g1 <- ggplot() +
      annotation_map_tile(zoom = 5) +
      geom_sf(data = quakes_sf) +
      geom_sf(data = quakes_bb, col = NA, fill = NA) +
      theme_void()

ggsave("vignettes/1.png", plot = g1, bg = "transparent", width = 5, height = 8.5)

quakes_pos <- hilbert::coords_to_position(quakes, coords = c("long", "lat"), n = 4L, attach = FALSE, extent = NULL)
quakes_grid <- sf::st_make_grid(quakes_sf, n = c(16, 16)) |>
               sf::st_as_sf()

quakes_grid$color <- "#808080"
quakes_grid$color[
    as.logical(rowSums(sf::st_intersects(quakes_grid, quakes_sf, sparse = FALSE)))
] <- "red"

g2 <- ggplot() +
      annotation_map_tile(zoom = 5) +
      geom_sf(data = quakes_grid, mapping = aes(col = color), fill = NA) +
      scale_color_identity() +
      geom_sf(data = quakes_sf) +
      geom_sf(data = quakes_bb, col = NA, fill = NA) +
      theme_void()

ggsave("vignettes/2.png", plot = g2, bg = "transparent", width = 5, height = 8.5)

quakes_index <- hilbert::index(quakes_pos, coords = c(1, 2), n = 4L, attach = FALSE)
quakes_hilbert <-
    sf::st_make_grid(quakes_sf, n = c(16, 16), what = "centers") |>
    sf::st_coordinates() |>
    as.data.frame()

quakes_hilbert$H <-
    hilbert::coords_to_position(
        quakes_hilbert,
        coords = c("X", "Y"),
        n = 4L,
        extent = NULL,
        attach = FALSE
    ) |>
    hilbert::index(n = 4L, attach = FALSE)

quakes_hilbert <- quakes_hilbert[order(quakes_hilbert$H), ] |>
                  sf::st_as_sf(coords = c("X", "Y"), crs = 4326) |>
                  sf::st_combine() |>
                  sf::st_cast("LINESTRING")

g3 <- g2 + geom_sf(data = quakes_hilbert, col = "purple", lwd = 3, alpha = 0.75)

ggsave("vignettes/3.png", plot = g3, bg = "transparent", width = 5, height = 8.5)
