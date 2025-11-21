# Parallel batching and chunking

``` r
library(mongolstats)
library(dplyr)
```

## Batch multiple tables

[`nso_package()`](https://temuulene.github.io/mongolstats/reference/nso_package.md)
accepts a list (or data frame) of requests and binds results.

``` r
reqs <- list(
  list(tbl_id = "DT_NSO_0300_001V2", selections = list(Year = "2024", Sex = "Total", Age = "Total"))
)
res <- tryCatch(nso_package(reqs, labels = "code"), error = function(e) tibble::tibble())
res %>% dplyr::slice_head(n = 5)
```

    ## # A tibble: 0 × 0

## Enable parallel batching

If `future.apply` is installed, set `parallel = TRUE` to compute
requests concurrently. Control workers with
[`future::plan()`](https://future.futureverse.org/reference/plan.html).

``` r
if (requireNamespace("future", quietly = TRUE) && requireNamespace("future.apply", quietly = TRUE)) {
  future::plan(future::multisession, workers = 2)
  res_par <- tryCatch(nso_package(reqs, labels = "code", parallel = TRUE), error = function(e) NULL)
  future::plan(future::sequential)
}
```

## Chunk large selections

To avoid very large requests, split a dimension into smaller chunks and
combine results.

``` r
years <- c("2020","2021","2022","2023","2024")
chunks <- split(years, ceiling(seq_along(years) / 2))  # chunks of 2
parts <- lapply(chunks, function(yrs) {
  tryCatch(nso_data("DT_NSO_0300_001V2", list(Year = yrs, Sex = "Total", Age = "Total"), labels = "code"), error = function(e) tibble::tibble())
})
res_chunked <- dplyr::bind_rows(parts)
if ("Year" %in% names(res_chunked)) {
  res_chunked %>% dplyr::count(Year)
} else {
  tibble::tibble()
}
```

    ## # A tibble: 0 × 0

## Progress bars

Enable package progress for multi-request batches. Sequential
(non-parallel) batches will display a progress bar when `cli` is
available and the session is interactive.

``` r
options(mongolstats.progress = TRUE)
res <- tryCatch(nso_package(reqs, labels = "code", parallel = FALSE), error = function(e) NULL)
```

Tips - Use caching
([`nso_cache_enable()`](https://temuulene.github.io/mongolstats/reference/nso_cache_enable.md))
to speed up metadata lookups. - Prefer chunking across the time
dimension or least-cardinality dimension. - Use `parallel = TRUE` for
independent requests, not for a single huge table fetch.
