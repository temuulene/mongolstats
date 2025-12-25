# Convert a query to a PXWeb body

Convert a query to a PXWeb body

## Usage

``` r
as_px_query(x, lang = .px_lang())
```

## Arguments

- x:

  An `nso_query` object.

- lang:

  PX language: "en" or "mn" (defaults to current option).

## Value

A list suitable to send as JSON body to PXWeb.

## Examples

``` r
q <- nso_query("DT_NSO_0300_001V2", list(Year = "2023"))
body <- as_px_query(q)
```
