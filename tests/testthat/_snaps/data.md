# nso_package() explains a bare record passed as `requests`

    Code
      nso_package(list(tbl_id = "DT_NSO_0300_001V2", selections = list()))
    Condition
      Error in `nso_package()`:
      ! `requests` must be a list of records, not a single record.
      i Wrap a single request in `list()`: `list(list(tbl_id = ..., selections = ...))`.

# nso_package() validates each record before fetching

    Code
      nso_package(list(list(selections = list(Year = "2024"))))
    Condition
      Error in `nso_package()`:
      ! Request 1 must be a list with a single-string tbl_id.

---

    Code
      nso_package(list(list(tbl_id = "T", selections = "2024")))
    Condition
      Error in `nso_package()`:
      ! Request 1 ("T") must have selections as a named list.
      i Use `selections = list(Year = "2024")`.

---

    Code
      nso_package("T")
    Condition
      Error in `nso_package()`:
      ! `requests` must be a list of records or a data frame with tbl_id + selections.
      i Each record should be a list with elements tbl_id and selections.

