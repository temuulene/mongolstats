# Create a PXWeb query object

Builds a lightweight query object that records a table id and
selections. Use
[`nso_fetch()`](https://temuulene.github.io/mongolstats/reference/nso_fetch.md)
to execute it, or
[`as_px_query()`](https://temuulene.github.io/mongolstats/reference/as_px_query.md)
to inspect the underlying PXWeb body.

## Usage

``` r
nso_query(tbl_id, selections = list())
```

## Arguments

- tbl_id:

  Table identifier, e.g. "DT_NSO_0300_001V2".

- selections:

  Named list mapping dimension labels (e.g., Year, Sex) to desired codes
  or labels.

## Value

An object of class `nso_query`.
