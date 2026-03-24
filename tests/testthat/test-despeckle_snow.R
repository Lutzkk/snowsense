test_that("despeckle_snow works on example binary raster", {

  library(terra)

  tif <- system.file(
    "extdata",
    "binary_snowmask.tif",
    package = "snowsense"
  )

  expect_true(file.exists(tif))

  r <- terra::rast(tif)

  out <- despeckle_snow(
    r,
    window = 3,
    min_pixels = 5
  )

  expect_s4_class(out, "SpatRaster")
  expect_true(all(values(out) %in% c(0, 1, NA)))
})
