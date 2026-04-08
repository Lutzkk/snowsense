# Example Sentinel-2 RGB+SWIR raster (20 m)

A small Sentinel-2 GeoTIFF included with the snowsense package for
demonstrations and testing. The raster contains four bands:

- Band 1:

  Coastal Aerosol (Sentinel-2 band 1)

- Band 2:

  Blue (Sentinel-2 band 2)

- Band 3:

  Green (Sentinel-2 band 3)

- Band 4:

  Red (Sentinel-2 band 4)

- Band 5:

  Red Edge 1 (Sentinel-2 band 5)

- Band 6:

  Red Edge 2 (Sentinel-2 band 6)

- Band 7:

  Red Edge 3 (Sentinel-2 band 7)

- Band 8:

  NIR (Sentinel-2 band 8)

- Band 9:

  Narrow NIR (Sentinel-2 band 8A)

- Band 10:

  SWIR 1 (Sentinel-2 band 11)

- Band 11:

  SWIR 2 (Sentinel-2 band 12)

## Details

The raster is located at the Zugspitzplatt in UTM zone 32N (EPSG:32632).

The file can be accessed with:

    system.file("extdata", "example_s2_rgb_swir_20m.tif", package = "snowsense")
