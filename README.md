# Snowsense
An R package for snow detection and fractional snow cover estimation from satellite imagery

## Installation
```r
# install.packages("devtools") # required to install packages from github 
devtools::install_github("Lutzkk/snowsense")
```
## Functions 
### `detect_snow(x, index, bands, threshold)`
Detects snow covered pixels from RGB or multispectral imagery using spectral indices.
**Parameters:**
- `x` -- SpatRaster containing the image
- `index` --  `"ndsi"`, `"wsi"` or `"rgb_brightness"`
- `bands` -- named list of band indices (e.g. `list(green=3, swir=11)`)  -- required bands depend on the chosen index
- `threshold` -- numeric threshold for binary snow/no-snow classification; if `NULL`, Otsu's method (Otsu, 1979) is applied automatically. It determines the optimal threshold by maximizing the variance between snow and non-snow pixel classes.

**Returns:** 
A list with: 
1) The index raster
2) The binary snow mask 
3) The Threshold value 
<details>
<summary>Methods</summary>
**Methods:**
_ndsi:_ 
The Normalized Difference Snow Index (NDSI) exploits the high reflectance of snow in the visible spectrum and its strong absorption in the shortwave infrared (SWIR)
  `NDSI = (R_green - R_SWIR) / (R_green + R_SWIR)`
  A commonly used threshold is 0.4

_rgb_brightness:_
Identifies snow based on its high brightness across the visible spectrum. Simple and fast
but may confuse snow with clouds or other bright surfaces
`Brightness = (R_red + R_green + R_blue) / 3`

_wsi:_
The Water-resistant Snow Index (WSI) combines brightness and hue in RGN (Red-Green-NIR) space, making it more robust against false positives from water and wet surfaces.   
`WSI = (V - H) / (V + H)` 
where V is pixel brightness (max of R,G, NIR) and H is the hue angle in RGN space
(Donmez et al., 2021)
</details>


