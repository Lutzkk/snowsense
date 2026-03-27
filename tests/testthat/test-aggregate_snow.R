test_that("aggregate_snow returns fractional snow cover", {
  tif <- system.file("extdata", "binary_snowmask.tif", package="snowsense")
  x <- terra::rast(tif)

  fsc <- aggregate_snow(x, fact=10)

  #output type
  expect_s4_class(fsc, "SpatRaster")

  #values are fractions of 0-1
  expect_true(terra::minmax(fsc)[1]>=0)
  expect_true(terra::minmax(fsc)[2]<=1)

  #resolution is coarser than original res
  expect_true(terra::res(fsc)[1] > terra::res(x)[1])
})
