# List tables under a sector or sub-sector (PXWeb path)

Filters the table catalogue to only those belonging to a given sector or
sub-sector path, as returned by
[`nso_sectors()`](https://temuulene.github.io/mongolstats/reference/nso_sectors.md)
or
[`nso_subsectors()`](https://temuulene.github.io/mongolstats/reference/nso_subsectors.md).

## Usage

``` r
nso_itms_by_sector(list_id)
```

## Arguments

- list_id:

  Path string from
  [`nso_sectors()`](https://temuulene.github.io/mongolstats/reference/nso_sectors.md)/[`nso_subsectors()`](https://temuulene.github.io/mongolstats/reference/nso_subsectors.md)
  `id`.

## Value

A tibble of tables matching the specified sector path.

## Examples

``` r
sectors <- nso_sectors()
tables <- nso_itms_by_sector(sectors$id[1])
```
