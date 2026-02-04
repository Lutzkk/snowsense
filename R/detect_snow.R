.compute_snow_index <- function(x, index, bands) {

  index <- tolower(index)

  if (index == "ndsi") {
    out <- (x[[bands$green]] - x[[bands$swir]]) /
      (x[[bands$green]] + x[[bands$swir]])

  } else if (index == "rgb_brightness") {
    out <- (x[[bands$red]] + x[[bands$green]] + x[[bands$blue]]) / 3

  } else if (index == "wsi") {

    #TODO: finish wsi index (doi: 10.1007/s00703-020-00749-y)

    #extract bands
    Rr <- x[[bands$red]]
    Rg <- x[[bands$green]]
    Rn <- x[[bands$nir]]


    # Hue engineering
    # (hue representing the angle in the feature space dsescribing
    # which band is dominating relative to the others (NOT RGB BUT RGN SPACE))

    wsi_fun <- function(v) {
      Rr <- v[1]; Rg <- v[2]; Rn <- v[3]

      #NaN Handling
      if (is.na(Rr) || is.na(Rg) || is.na(Rn)) return(NA_real_)

      Cmax <- max(Rr, Rg, Rn)
      Cmin <- min(Rr, Rg, Rn)
      delta <- Cmax - Cmin

      V <- Cmax #brightness value

      if (delta == 0) {
        H <- 0
      } else if (Cmax == Rr) {
        H <- ((Rg - Rn) / delta) %% 6
      } else if (Cmax == Rg) {
        H <- ((Rn - Rr) / delta) + 2
      } else {
        H <- ((Rr - Rg) / delta) + 4
      }

      H <- H/6

      (V-H)/(V + H)
    }
    out <- terra::app(c(Rr, Rg, Rn), fun = wsi_fun)

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
    bands = list(
      aerosol=1,
      blue=2,
      green=3,
      red=4,
      red_edge1=5,
      red_edge2=6,
      red_edge3=7,
      nir=8,
      narrow_nir=9,
      swir1=10,
      swir2=11
    ),
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
