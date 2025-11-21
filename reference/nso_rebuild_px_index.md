# Rebuild PXWeb index and optionally write to a file

Rebuild PXWeb index and optionally write to a file

## Usage

``` r
nso_rebuild_px_index(
  path = file.path("inst", "extdata", "px_index.json"),
  write = TRUE
)
```

## Arguments

- path:

  Output path for JSON (default 'inst/extdata/px_index.json' in dev
  trees)

- write:

  Whether to write JSON to `path` (default TRUE)

## Value

tibble index
