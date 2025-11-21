## Internal shims to back cache helpers

# These provide concrete definitions so the memoised wrappers in cache.R
# can bind and so that R CMD check does not flag undefined references.

.fetch_itms_raw <- function() {
  nso_px_tables()
}

.fetch_detail_raw <- function(tbl_id) {
  nso_px_variables(tbl_id)
}
