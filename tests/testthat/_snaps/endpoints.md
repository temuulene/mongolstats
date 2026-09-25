# nso_itms_by_sector() validates list_id

    Code
      nso_itms_by_sector(NULL)
    Condition
      Error in `nso_itms_by_sector()`:
      ! `list_id` must be a single character string, not NULL.

---

    Code
      nso_itms_by_sector(c("a", "b"))
    Condition
      Error in `nso_itms_by_sector()`:
      ! `list_id` must be a single character string, not a character vector.

