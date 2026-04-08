# Detects snow-covered areas from optical imagery using different spectral indices and brightness based approaches.

Detects snow-covered areas from optical imagery using different spectral
indices and brightness based approaches.

## Usage

``` r
detect_snow(
  x,
  index = "ndsi",
  bands = list(aerosol = 1, blue = 2, green = 3, red = 4, red_edge1 = 5, red_edge2 = 6,
    red_edge3 = 7, nir = 8, narrow_nir = 9, swir1 = 10, swir2 = 11),
  threshold = NULL
)
```

## Arguments

- x:

  SpatRaster - A tif containing multiple bands from a multispectral
  image

- index:

  Character - The Index to use (currently supports "ndsi", "wsi" and
  "rgb_brightness")

- bands:

  Named list with band indices for green, swir, red, and blue bands

- threshold:

  Numeric or NULL Threshold value for snow detection. If NULL, Otsu's
  method is used to determine the threshold.

## Value

Returns a list with three elements: the indexed Tif (SpatRaster), the
binary snow mask (SpatRaster), and the threshold value(numeric).

## Details

**NDSI (Normalized Difference Snow Index)**  
The NDSI is a very commonly used spectral index for snow detection. It
utilizes the high reflectance of snow in the visible domain (usually
green) and its strong absorption in the shortwave infrared (SWIR)
domain. A commonly used threshold is 0.4.

**RGB Brightness**  
This method identifies snow based on its high brightness in the visible
spectrum. Brightness is computed as the mean reflectance of the red,
green, and blue bands. While simple and fast, this approach may confuse
snow with clouds or other bright surfaces. Threshold depends on the
datatype and range of the input data (Otsu performs badly here).

**WSI (Water-Resistant Snow Index)**  
WSI is computed from HSV-transformed red, green and nir bands by
combining pixel-wise brightness (value) and spectral color (hue),
enabling robust discrimination of snow-covered areas based on their high
reflectance and low spectral variability relative to water and
vegetation. doi: 10.1007/s00703-020-00749-y

## Examples

``` r
# NDSI based snow detection
detect_snow(x, index="ndsi",
            bands=list(green=2,swir=4),threshold=NULL)
#> Error: object 'x' not found
# # RGB Brightness based snow detection
detect_snow(x, index="rgb_brightness",
            bands=list(red=3,green=2,blue=1),threshold=NULL)
#> Error: object 'x' not found
# WSI based snow detection
detect_snow(x, index="wsi",
            bands=list(red=3,green=2,nir=5),threshold=NULL)
#> Error: object 'x' not found

```
