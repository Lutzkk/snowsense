.compute_snow_index <- function(x, index, bands) {

  index <- tolower(index)

  if (index == "ndsi") {
    out <- (x[[bands$green]] - x[[bands$swir]]) /
      (x[[bands$green]] + x[[bands$swir]])

  } else if (index == "rgb_brightness") {
    out <- (x[[bands$red]] + x[[bands$green]] + x[[bands$blue]]) / 3

  } else if (index == "wsi") {

    #extract bands
    Rr <- x[[bands$red]]
    Rg <- x[[bands$green]]
    Rn <- x[[bands$nir]]

    if (any(terra::global(c(Rr,Rg,Rn), "max", na.rm=TRUE) > 1))
      warning("Pixel values > 1 detected. WSI expects normalized reflectance values([0,1]).")

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


#' Detects snow-covered areas from optical imagery using different spectral indices and brightness based approaches.
#'
#' @details
#' \strong{NDSI (Normalized Difference Snow Index)}\cr
#' The NDSI is a very commonly used spectral index for snow detection. It utilizes the high
#' reflectance of snow in the visible domain (usually green) and its strong absorption in the
#' shortwave infrared (SWIR) domain. A commonly used threshold is 0.4.
#'
#' \strong{RGB Brightness}\cr
#' This method identifies snow based on its high brightness in the visible spectrum.
#' Brightness is computed as the mean reflectance of the red, green, and blue bands.
#' While simple and fast, this approach may confuse snow with clouds or other bright
#' surfaces. Threshold depends on the datatype and range of the input data (Otsu performs
#' badly here).
#'
#' \strong{WSI (Water-Resistant Snow Index)}\cr
#' WSI is computed from HSV-transformed red, green and nir bands by combining pixel-wise
#' brightness (value) and spectral color (hue), enabling robust discrimination of snow-covered
#' areas based on their high reflectance and low spectral variability relative to water and
#' vegetation. doi:10.1007/s00703-020-00749-y
#' @param x SpatRaster - A tif containing multiple bands from a multispectral image
#' @param index Character - The Index to use (currently supports "ndsi", "wsi" and "rgb_brightness")
#' @param bands Named list with band indices for green, swir, red, and blue bands
#' @param threshold Numeric or NULL Threshold value for snow detection. If NULL, Otsu's method is used to determine the threshold.
#'
#' @returns Returns a list with three elements: the indexed Tif (SpatRaster), the binary snow mask (SpatRaster), and the threshold value(numeric).
#' @export
#'
#' @examples
#' # NDSI based snow detection
#' detect_snow(x, index="ndsi",
#'             bands=list(green=2,swir=4),threshold=NULL)
#' # # RGB Brightness based snow detection
#' detect_snow(x, index="rgb_brightness",
#'             bands=list(red=3,green=2,blue=1),threshold=NULL)
#' # WSI based snow detection
#' detect_snow(x, index="wsi",
#'             bands=list(red=3,green=2,nir=5),threshold=NULL)
#'
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
      water_vapor=10,
      cirrus=11,
      swir1=12,
      swir2=13
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
  snow <- terra::ifel(idx > threshold, 1, 0)

  #Return
  list(
    index = idx,
    binary_mask = snow,
    threshold = threshold
  )
}

