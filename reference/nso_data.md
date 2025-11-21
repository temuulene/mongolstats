# Fetch statistical data for a table (PXWeb)

Fetch statistical data for a table (PXWeb)

## Usage

``` r
nso_data(
  tbl_id,
  selections,
  labels = c("none", "en", "mn", "both"),
  value_name = getOption("mongolstats.value_name", "value"),
  include_raw = getOption("mongolstats.attach_raw", FALSE)
)
```

## Arguments

- tbl_id:

  Table identifier (e.g., "DT_NSO_0300_001V2").

- selections:

  Named list mapping variable labels (e.g., Year, Sex) to desired codes
  or labels.

- labels:

  Label handling: "none" (codes only), "en", "mn", or "both".

- value_name:

  Name of the numeric value column in the result (default: "value").

- include_raw:

  If TRUE, attach the raw PX payload as attribute `px_raw`.
