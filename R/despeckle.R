.despeckle_majority <- function(x, window, threshold=NULL) {
  stopifnot(inherits(x, "SpatRaster"))
  stopifnot(window %% 2==1) #window has to be odd so there is a center

  if (is.null(threshold)) {
    threshold <- floor(window*window/2) + 1
  }

  w <- matrix(1, window, window)

  terra::focal(
    x,
    w=w,
    fun=function(v) {
      if (sum(v, na.rm=TRUE) >= threshold) 1 else 0
    },
    na.policy="omit",
    fillvalue=NA_real_
  )
}

.despeckle_min_area <- function(x, min_pixels){
  stopifnot(inherits(x, "SpatRaster"))

  patches <- terra::patches(x, directions=8)
  freq <- terra::freq(patches)

  if (nrow(freq)==0) return(x)

  small_ids <- freq$value[freq$count < min_pixels]
  mask <- terra::app(
    patches,
    fun = function(v) {
      v %in% small_ids
    }
  )

  x[mask] <- 0
  x
}



#' Despeckles snow patches based on a binary snow mask (1==snow, 0==no snow)
#'
#'
#' @param x SpatRaster - Binary snow mask (1 == snow, 0 == no snow)
#' @param window Integer - Odd-Sized neighborhood window for majority filtering
#' @param threshold  Integer or NULL - Neighborhood threshold.  If NULL, strict majority is used.
#' @param min_pixels Integer - Minimum numbers of connected pixels required for snow patch to be retained.
#'
#' @returns SpatRaster - Despeckled binary snow mask
#' @export
#'
#' @examples
#' #Basic majority-based despeckling
#' snow_clean <- despeckle_snow(
#' x,
#' window = 3
#' )
#'
#'#Remove all isolated snowpatches
#'snow_clean <- despeckle_snow(
#'x,
#'window=3,
#'min_pixels=10
#')
#'
despeckle_snow <- function(
    x,
    window = NULL,
    threshold = NULL,
    min_pixels = NULL
) {

  stopifnot(inherits(x, "SpatRaster"))

  # 1. Majority-based despeckling
  if (!is.null(window)) {
    x <- .despeckle_majority(
      x,
      window = window,
      threshold = threshold
    )
  }
  # 2. Object-size cleanup
  if (!is.null(min_pixels)) {
    x <- .despeckle_min_area(
      x,
      min_pixels = min_pixels
    )
  }

  x
}
