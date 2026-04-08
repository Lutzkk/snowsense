# Aggregates a binary snow mask to a fractional snow cover raster

Aggregates a binary snow mask to a fractional snow cover raster

## Usage

``` r
aggregate_snow(x, fact)
```

## Arguments

- x:

  SpatRaster - Binary snow mask (1 == snow, 0 == no snow)

- fact:

  Integer - Aggregation factor (number of pixels in each direction)

## Value

Continuous SpatRaster with snow cover fraction (0-1) per aggregated cell

## Examples

``` r
fsc <- aggregate_snow(x, fact=10)
#> Error: object 'x' not found
```
