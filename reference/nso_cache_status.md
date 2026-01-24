# Cache status

Report current cache configuration and basic stats.

## Usage

``` r
nso_cache_status()
```

## Value

A list with `enabled`, `dir`, and `has_cache`.

## Examples

``` r
nso_cache_status()
#> $enabled
#> [1] FALSE
#> 
#> $dir
#> [1] "/tmp/RtmpYSoUtO"
#> 
#> $has_cache
#> [1] TRUE
#> 
```
