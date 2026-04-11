#' Example Sentinel-2 RGB+SWIR raster (20 m)
#'
#' A small Sentinel-2 GeoTIFF included with the snowsense package
#' for demonstrations and testing.
#' The raster contains 13 bands:
#' \describe{
#'   \item{Band 1 (B01)}{Coastal Aerosol}
#'   \item{Band 2 (B02)}{Blue}
#'   \item{Band 3 (B03)}{Green}
#'   \item{Band 4 (B04)}{Red}
#'   \item{Band 5 (B05)}{Red Edge 1}
#'   \item{Band 6 (B06)}{Red Edge 2}
#'   \item{Band 7 (B07)}{Red Edge 3}
#'   \item{Band 8 (B08)}{NIR}
#'   \item{Band 9 (B8A)}{Narrow NIR}
#'   \item{Band 10 (B09)}{Water Vapour}
#'   \item{Band 11 (B10)}{Cirrus}
#'   \item{Band 12 (B11)}{SWIR 1}
#'   \item{Band 13 (B12)}{SWIR 2}
#' }
#'
#' The raster is located at the
#' Zugspitzplatt in UTM zone 32N (EPSG:32632).
#'
#' @docType data
#' @name example_s2_20m
#' @keywords datasets
#'
#' @details
#' The file can be accessed with:
#' \preformatted{
#' system.file("extdata", "example_s2_20m.tif", package = "snowsense")
#' }
NULL

