# Despeckles snow patches based on a binary snow mask (1 == snow, 0 == no snow)

Despeckles snow patches based on a binary snow mask (1 == snow, 0 == no
snow)

## Usage

``` r
despeckle_snow(x, window = NULL, threshold = NULL, min_pixels = NULL)
```

## Arguments

- x:

  SpatRaster - Binary snow mask (1 == snow, 0 == no snow)

- window:

  Integer - Odd-Sized neighborhood window for majority filtering

- threshold:

  Integer or NULL - Neighborhood threshold. If NULL, strict majority is
  used.

- min_pixels:

  Integer - Minimum numbers of connected pixels required for snow patch
  to be retained.

## Value

SpatRaster - Despeckled binary snow mask

## Examples

``` r
#Basic majority-based despeckling
snow_clean <- despeckle_snow(
x,
window = 3
)
#> Error: object 'x' not found

#Remove all isolated snowpatches
snow_clean <- despeckle_snow(
x,
window=3,
min_pixels=10
)
#> Error: object 'x' not found
```
