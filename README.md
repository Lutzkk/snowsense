# Snowsense

An R package aimed to facilitate snow detection and fractional snow cover estimation from satellite imagery. 
For further details please refer to the [package website](https://lutzkk.github.io/snowsense/articles/snowsense-example.html).

## Installation

```r
# install.packages("devtools") # required to install packages from github
devtools::install_github("Lutzkk/snowsense")
```

## Functions

### `detect_snow(x, index, bands, threshold)`

Detects snow covered pixels from RGB or multispectral imagery using different spectral indices.

<details>
<summary>Parameters</summary>

- `x` -- SpatRaster containing the image
- `index` -- `"ndsi"`, `"wsi"` or `"rgb_brightness"`
- `bands` -- named list of band indices (e.g. `list(green=3, swir=12)`) -- required bands depend on the chosen index
- `threshold` -- numeric threshold for binary snow/no-snow classification; if `NULL`, Otsu's method (Otsu, 1979) is applied automatically. It determines the optimal threshold by maximizing the variance between snow and non-snow pixel classes.

</details>

<details>
<summary>Returns</summary>

A list with:

1. The index raster
2. The binary snow mask
3. The threshold value

</details>

<details>
<summary>Methods</summary>

_ndsi:_
The Normalized Difference Snow Index (NDSI) exploits the high reflectance of snow in the visible spectrum and its strong absorption in the shortwave infrared (SWIR).
`NDSI = (R_green - R_SWIR) / (R_green + R_SWIR)`
A commonly used threshold is 0.4.

_rgb_brightness:_
Identifies snow based on its high brightness across the visible spectrum. Simple and fast but may confuse snow with clouds or other bright surfaces.
`Brightness = (R_red + R_green + R_blue) / 3`

_wsi:_
The Water-resistant Snow Index (WSI) combines brightness and hue in RGN (Red-Green-NIR) space, making it more robust against false positives from water and wet surfaces.
`WSI = (V - H) / (V + H)`
where V is pixel brightness (max of R, G, NIR) and H is the hue angle in RGN space
(Donmez et al., 2021)

</details>

<details>
<summary>Example</summary>

```r
tif <- system.file("extdata", "example_s2_20m.tif", package = "snowsense")
x <- terra::rast(tif)

result <- detect_snow(x, index = "ndsi", bands = list(green = 3, swir = 12))

result$index        # index raster
result$binary_mask  # binary snow mask
result$threshold    # applied threshold
```

</details>

---

### `despeckle_snow(x, window, threshold, min_pixels)`

Removes speckle noise from a binary snow mask using majority filtering and/or minimum patch size.

<details>
<summary>Parameters</summary>

- `x` -- SpatRaster, binary snow mask (1 = snow, 0 = no snow)
- `window` -- odd integer, neighborhood window size for majority filtering; if `NULL`, skipped
- `threshold` -- integer, minimum number of snow pixels in window to classify center pixel as snow; if `NULL`, strict majority is used
- `min_pixels` -- integer, minimum number of connected pixels for a snow patch to be retained; if `NULL`, skipped

</details>

<details>
<summary>Returns</summary>

SpatRaster — despeckled binary snow mask.

</details>

<details>
<summary>Example</summary>

```r
tif <- system.file("extdata", "binary_snowmask.tif", package = "snowsense")
x <- terra::rast(tif)

# Majority-based despeckling
clean <- despeckle_snow(x, window = 3)

# Also remove small isolated patches
clean <- despeckle_snow(x, window = 3, min_pixels = 10)
```

</details>

---

### `aggregate_snow(x, fact)`

Aggregates a binary snow mask to a coarser resolution, returning fractional snow cover per cell.

<details>
<summary>Parameters</summary>

- `x` -- SpatRaster, binary snow mask (1 = snow, 0 = no snow)
- `fact` -- integer, aggregation factor (number of pixels per direction)

</details>

<details>
<summary>Returns</summary>

SpatRaster — continuous raster with snow cover fraction (0–1) at coarser resolution.

</details>

<details>
<summary>Example</summary>

```r
tif <- system.file("extdata", "binary_snowmask.tif", package = "snowsense")
x <- terra::rast(tif)

fsc <- aggregate_snow(x, fact = 10)
```

</details>

---

### `snow_cover_fraction(x, bands, method)`

Estimates Fractional Snow Cover (FSC) directly from a multispectral image using NDSI-based regression. Unlike `aggregate_snow`, this operates at the original resolution and estimates sub-pixel snow cover.

<details>
<summary>Parameters</summary>

- `x` -- SpatRaster, multispectral image
- `bands` -- named list with `"green"` and `"swir"` band indices
- `method` -- `"salomonson"` (linear regression, Salomonson & Appel 2004) or `"sigmoid"` (Gascoin et al. 2020)

</details>

<details>
<summary>Returns</summary>

SpatRaster — FSC values clamped to [0, 1].

</details>

<details>
<summary>Methods</summary>

_salomonson:_
Linear regression fitted to MODIS data.
`FSC = 1.45 * NDSI - 0.01`
(Salomonson & Appel, 2004)

_sigmoid:_
Sigmoid regression, more robust at high and low NDSI values.
`FSC = 0.5 * tanh(2.65 * NDSI - 1.42) + 0.5`
(Gascoin et al., 2020)

</details>

<details>
<summary>Example</summary>

```r
tif <- system.file("extdata", "example_s2_20m.tif", package = "snowsense")
x <- terra::rast(tif)

scf <- snow_cover_fraction(x, bands = list(green = 3, swir = 12), method = "salomonson")
```

</details>

## References

Donmez, C., Berberoglu, S., Cicekli, S. Y., Cilek, A., & Arslan, A. N. (2021). Mapping snow cover using Landsat data: Toward a fine-resolution water-resistant snow index. *Meteorology and Atmospheric Physics*, *133*(2), 281–294. https://doi.org/10.1007/s00703-020-00749-y

Gascoin, S., Barrou Dumont, Z., Deschamps-Berger, C., Marti, F., Salgues, G., López-Moreno, J. I., Revuelto, J., Michon, T., Schattan, P., & Hagolle, O. (2020). Estimating fractional snow cover in open terrain from Sentinel-2 using the normalized difference snow index. *Remote Sensing*, *12*(18), 2904. https://doi.org/10.3390/rs12182904

Otsu, N. (1979). A threshold selection method from gray-level histograms. *IEEE Transactions on Systems, Man, and Cybernetics*, *9*(1), 62–66. https://doi.org/10.1109/TSMC.1979.4310076

Salomonson, V. V., & Appel, I. (2004). Estimating fractional snow cover from MODIS using the normalized difference snow index. *Remote Sensing of Environment*, *89*(3), 351–360. https://doi.org/10.1016/j.rse.2003.10.016
