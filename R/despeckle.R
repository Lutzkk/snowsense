.despeckle_majority <- function(x, window, threshold=NULL) {
  stopifnot(inherits(x, "SpatRaster"))
  stopifnot(window %% 2==1)

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
    fillvalue=NA_real_,
  )
}

.despeckle_distance <- function(x, max_distance){
  stopifnot(inherits(x, "SpatRaster"))

  d <- terra::distance(x)
  x[d > max_distance] <- 0
}

.despeckle_min_area <- function(x, min_pixels){
  stopifnot(inherits(x, "SpatRaster"))

  patches <- terra::patches(x, directions=8)
  freq <- terra::freq(patches, useNA="no")

  if (nrow(freq)==0) return(x)

  small_ids <- freq$value[freq$count < min_pixels]
  x[patches %in% small_ids] <- 0
  x
}



#' Despeckles snow patches based on a binary snow mask (1==snow, 0==no snow)
#'
#'
#' @param x Spatraster - Binary snow mask (1 == snow, 0 == no snow)
#' @param window Integer - Odd-Sized neighborhood window for majority filtering
#' @param threshold - Integer or NULL. Neighborhood threshold.  If NULL, strict majority is used.
#' @param max_distance - Numeric or NULL: Maximum allowed dsitance to other snow pixles (map units)
#' @param min_pixels - Integer or NULL. Minimum numbers of connected pixels required for snow patch to be retained.
#'
#' @returns Spatraster - Despeckled binary snow mask
#' @export
#'
#' @examples
despeckle_snow <- function(
    x,
    window = 3,
    threshold = NULL,
    max_distance = NULL,
    min_pixels = NULL
) {

  stopifnot(inherits(x, "SpatRaster"))

  # 1. Neighborhood consistency
  x <- .despeckle_majority(
    x,
    window = window,
    threshold = threshold
  )

  # 2. Distance-based cleanup
  if (!is.null(max_distance)) {
    x <- .despeckle_distance(
      x,
      max_distance = max_distance
    )
  }

  # 3. Object-size cleanup
  if (!is.null(min_pixels)) {
    x <- .despeckle_min_area(
      x,
      min_pixels = min_pixels
    )
  }

  x
}
