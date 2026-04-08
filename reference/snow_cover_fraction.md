# Estimate Snow Cover Fraction (SCF) from NDSI

Estimate Snow Cover Fraction (SCF) from NDSI

## Usage

``` r
snow_cover_fraction(x, bands, method)
```

## Arguments

- x:

  Spatraster - Multispectral image

- bands:

  Named list with "green" and "swir" band indices

- method:

  Character - Either "salomonson" (Salomonson & Appel, 2004) or
  "sigmoid" (Gascoin et al., 2020)

## Value

Spatraster with Snow Cover Fraction values (clipped to 0-1)

## Examples

``` r
scf <- snow_cover_fraction(x, bands=list(green=3, swir=10), method="salomonson")
#> Error: object 'x' not found
```
