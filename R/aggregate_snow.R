#' Aggregates a binary snow mask to a fractional snow cover raster
#'
#' @param x SpatRaster - Binary snow mask (1 == snow, 0 == no snow)
#' @param fact Integer - Aggregation factor (number of pixels in each direction)
#'
#' @returns Continuous SpatRaster with snow cover fraction (0-1) per aggregated cell
#' @export
#'
#' @examples
#' fsc <- aggregate_snow(x, fact=10)
aggregate_snow <- function(x, fact) {
  stopifnot(inherits(x, "SpatRaster"))
  stopifnot(is.numeric(fact), fact >= 1)

  terra::aggregate(x, fact = fact, fun = "mean", na.rm = TRUE)
}
