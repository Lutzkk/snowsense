# Example Sentinel-2 RGB+SWIR raster (20 m)

A small Sentinel-2 GeoTIFF included with the snowsense package for
demonstrations and testing. The raster contains 13 bands:

- Band 1 (B01):

  Coastal Aerosol

- Band 2 (B02):

  Blue

- Band 3 (B03):

  Green

- Band 4 (B04):

  Red

- Band 5 (B05):

  Red Edge 1

- Band 6 (B06):

  Red Edge 2

- Band 7 (B07):

  Red Edge 3

- Band 8 (B08):

  NIR

- Band 9 (B8A):

  Narrow NIR

- Band 10 (B09):

  Water Vapour

- Band 11 (B10):

  Cirrus

- Band 12 (B11):

  SWIR 1

- Band 13 (B12):

  SWIR 2

## Details

The raster is located at the Zugspitzplatt in UTM zone 32N (EPSG:32632).

The file can be accessed with:

    system.file("extdata", "example_s2_20m.tif", package = "snowsense")
