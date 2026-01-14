#' Example Sentinel-2 RGB+SWIR raster (20 m)
#'
#' A small Sentinel-2 GeoTIFF included with the snowsense package
#' for demonstrations and testing.
#' The raster contains four bands:
#' \describe{
#'   \item{Band 1}{Coastal Aerosol (Sentinel-2 band 1)}
#'   \item{Band 2}{Blue (Sentinel-2 band 2)}
#'   \item{Band 3}{Green (Sentinel-2 band 3)}
#'   \item{Band 4}{Red (Sentinel-2 band 4)}
#'   \item{Band 5}{Red Edge 1 (Sentinel-2 band 5)}
#'   \item{Band 6}{Red Edge 2 (Sentinel-2 band 6)}
#'   \item{Band 7}{Red Edge 3 (Sentinel-2 band 7)}
#'   \item{Band 8}{NIR (Sentinel-2 band 8)}
#'   \item{Band 9}{Narrow NIR (Sentinel-2 band 8A)}
#'   \item{Band 10}{SWIR 1 (Sentinel-2 band 11)}
#'   \item{Band 11}{SWIR 2 (Sentinel-2 band 12)}
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
#' system.file("extdata", "example_s2_rgb_swir_20m.tif", package = "snowsense")
#' }
NULL

