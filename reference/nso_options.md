# Set or get mongolstats options

Convenience wrapper around
[`base::options()`](https://rdrr.io/r/base/options.html) for
mongolstats.

## Usage

``` r
nso_options(...)
```

## Arguments

- ...:

  Named options to set. If empty, returns a named list of current
  mongolstats options.

## Value

Invisibly, the previous values of the options changed, or a list of
current values when called with no arguments.
