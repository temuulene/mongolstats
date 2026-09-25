# nso_table_periods validates tbl_id like other discovery helpers

    Code
      nso_table_periods("DT_NSO_NON_EXISTENT")
    Condition
      Error in `nso_table_periods()`:
      ! Table "DT_NSO_NON_EXISTENT" not found in PXWeb index.
      i Find table ids with `nso_search()` or `nso_itms()`.

---

    Code
      nso_table_periods(NULL)
    Condition
      Error in `nso_table_periods()`:
      ! `tbl_id` must be a single character string, not NULL.

