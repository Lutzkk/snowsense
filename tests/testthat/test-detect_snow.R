test_that("detect_snow loads test tif and returns expected outputs", {

  tif <- system.file(
    "extdata",
    "example_s2_rgb_swir_20m.tif",
    package = "snowsense"
  )

  expect_true(file.exists(tif))

  x <- terra::rast(tif)

  res <- detect_snow(x)

  expect_type(res, "list")
  expect_named(res, c("index", "snow_mask", "threshold"))

  expect_s4_class(res$index, "SpatRaster")
  expect_s4_class(res$snow_mask, "SpatRaster")
  expect_true(is.numeric(res$threshold))
})
