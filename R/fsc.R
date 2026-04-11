#' Estimate Snow Cover Fraction (SCF) from NDSI
#'
#' @param x Spatraster - Multispectral image
#' @param bands Named list with "green" and "swir" band indices
#' @param method Character - Either "salomonson" (Salomonson & Appel, 2004) or "sigmoid" (Gascoin et al., 2020)
#'
#' @returns Spatraster with Snow Cover Fraction values (clipped to 0-1)
#' @export
#'
#' @examples scf <- snow_cover_fraction(x, bands=list(green=3, swir=12), method="salomonson")
snow_cover_fraction <- function(x, bands, method) {
  stopifnot(inherits(x, "SpatRaster"))
  method <- tolower(method) #circumvent uppercase typos

  ndsi <- .compute_snow_index(x, index="ndsi", bands=bands) # calls helper function
  scf <- if (method=="salomonson") {
    1.45*ndsi-0.01 # Salomonson and Appel (2004)
  } else if (method=="sigmoid") {
    0.5*tanh(2.65*ndsi-1.42)+0.5 # Gascoin et al. (2020)
  } else{
    stop("Unknown method:", method, ". Use 'salomonson' or 'sigmoid'.")
  }
  terra::clamp(scf, lower=0, upper=1) #salomonson can produce values outside 0-1 -> clip to there
  }

