# Rebuild PXWeb index and optionally write to a file

Crawls the PXWeb API to rebuild the table index. If `path` is provided,
the index is written to that file; otherwise only the in-memory index is
refreshed.

## Usage

``` r
nso_rebuild_px_index(path = NULL, write = !is.null(path))
```

## Arguments

- path:

  Output path for JSON. If `NULL` (default), no file is written. For
  package development, use `"inst/extdata/px_index.json"`.

- write:

  Whether to write JSON to `path`. Defaults to `TRUE` if `path` is
  provided, `FALSE` otherwise.

## Value

A tibble containing the rebuilt table index.
