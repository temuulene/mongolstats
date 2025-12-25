# Enable offline mode

When enabled, HTTP requests are prevented and functions that require the
network will raise a clear offline error. Cached metadata can still be
used if already available via
[`nso_cache_enable()`](https://temuulene.github.io/mongolstats/reference/nso_cache_enable.md).

## Usage

``` r
nso_offline_enable()
```

## Value

Invisibly, `TRUE`.

## Examples

``` r
# Enable offline mode
nso_offline_enable()

# Check the option was set
getOption("mongolstats.offline")
#> [1] TRUE

# Disable to restore normal operation
nso_offline_disable()
```
