.compute_snow_index <- function(x, index, bands) {

  index <- tolower(index)

  if (index == "ndsi") {
    out <- (x[[bands$green]] - x[[bands$swir]]) /
      (x[[bands$green]] + x[[bands$swir]])

  } else if (index == "rgb_brightness") {
    out <- (x[[bands$red]] + x[[bands$green]] + x[[bands$blue]]) / 3

  } else {
    stop("Unknown index: ", index)
  }

  names(out) <- toupper(index)
  out
}

.otsu_threshold <- function(x, n_bins = 256) {

  h <- terra::hist(x, breaks = n_bins, plot = FALSE)

  counts <- h$counts
  mids   <- h$mids

  p <- counts / sum(counts)
  omega <- cumsum(p)
  mu <- cumsum(p * mids)
  mu_t <- mu[length(mu)]

  sigma_b <- (mu_t * omega - mu)^2 / (omega * (1 - omega))

  mids[which.max(sigma_b)]
}


#' Detect Snow using Spectral Indices
#'
#' @param x SpatRaster - A tif containing multiple bands from a multispectral image
#' @param index Character - The Index to use (currently supports "ndsi" and "rgb_brightness")
#' @param bands Named list with band indices for green, swir, red, and blue bands
#' @param threshold Numeric or NULL Threshold value for snow detection. If NULL, Otsu's method is used to determine the threshold.
#'
#' @returns A list with three elements: the indexed Tif (SpatRaster), the binary snow mask (SpatRaster), and the threshold value(numeric).
#' @export
#'
#' @examples detect_snow(x, index="ndsi", bands=list(green=2,swir=4),threshold=NULL)
#'
detect_snow <- function(
    x,
    index = "ndsi",
    bands = list(green = 2, swir = 4, red = 1, blue = 3),
    threshold = NULL
) {

  #Compute spectral index
  idx <- .compute_snow_index(x, index, bands)

  #Determine threshold
  if (is.null(threshold)) {
    threshold <- .otsu_threshold(idx)
  }

  #Binarize
  snow <- idx > threshold

  #Return
  list(
    index = idx,
    binary_mask = snow,
    threshold = threshold
  )
}
