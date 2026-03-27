test_that("snow_cover_fraction works for both methods", {

  tif <- system.file("extdata", "example_s2_20m.tif", package= "snowsense")
  x <- terra::rast(tif)

  scf_sal <- snow_cover_fraction(x, bands=list(green=3, swir=10), method="salomonson")
  scf_sig <- snow_cover_fraction(x, bands=list(green=3, swir=10), method="sigmoid")


  #output type
  expect_s4_class(scf_sal, "SpatRaster")
  expect_s4_class(scf_sig, "SpatRaster")


  #values clamped to [0, 1]
  expect_true(terra::minmax(scf_sal)[1]>=0)
  expect_true(terra::minmax(scf_sal)[2]<=1)

  expect_true(terra::minmax(scf_sig)[1]>=0)
  expect_true(terra::minmax(scf_sig)[2]<=1)



  #mothods produce different results
  expect_false(isTRUE(all.equal(terra::values(scf_sal), terra::values(scf_sig))))

  #invalid methods throws error.
  expect_error(snow_cover_fraction(x, bands=list(green=3, swir=10), method="some random method that does not exist"))
})
