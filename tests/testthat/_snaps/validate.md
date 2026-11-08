# check_tbl_id rejects non-string input

    Code
      check_tbl_id(123)
    Condition
      Error:
      ! `tbl_id` must be a single character string, not a number.

---

    Code
      check_tbl_id(NULL)
    Condition
      Error:
      ! `tbl_id` must be a single character string, not NULL.

---

    Code
      check_tbl_id(c("a", "b"))
    Condition
      Error:
      ! `tbl_id` must be a single character string, not a character vector.

# check_selections rejects malformed selections

    Code
      check_selections("not a list")
    Condition
      Error:
      ! `selections` must be a named list of values.
      i Use `list(Year = "2023", Sex = "Total")`.

---

    Code
      check_selections(list("2023"))
    Condition
      Error:
      ! All elements of `selections` must be named.
      i Use `list(Year = "2023", Sex = "Total")`.

---

    Code
      check_selections(list(Year = "2023", year = "2024"))
    Condition
      Error:
      ! Duplicated name in `selections`: "year".
      i Combine values into one vector, e.g. `list(Year = c("2023", "2024"))`.

# check_query rejects non-string input

    Code
      check_query(123)
    Condition
      Error:
      ! `query` must be a single character string, not a number.

---

    Code
      check_query(NULL)
    Condition
      Error:
      ! `query` must be a single character string, not NULL.

---

    Code
      check_query(c("a", "b"))
    Condition
      Error:
      ! `query` must be a single character string, not a character vector.

# string validators reject missing and blank values

    Code
      check_tbl_id(NA_character_)
    Condition
      Error:
      ! `tbl_id` must be a non-empty table identifier.

---

    Code
      check_tbl_id("  ")
    Condition
      Error:
      ! `tbl_id` must be a non-empty table identifier.

---

    Code
      check_query(NA_character_)
    Condition
      Error:
      ! `query` must be a non-empty search term.
      i List every table with `nso_tables()`.

---

    Code
      check_query("")
    Condition
      Error:
      ! `query` must be a non-empty search term.
      i List every table with `nso_tables()`.

# missing path and dimension arguments fail before any request

    Code
      nso_dim_values("T", NA_character_)
    Condition
      Error in `nso_dim_values()`:
      ! `dim` must be a single non-empty character string.

---

    Code
      nso_subsectors(NA_character_)
    Condition
      Error in `nso_subsectors()`:
      ! `subid` must be a single character string.

---

    Code
      nso_data(NA_character_, list())
    Condition
      Error in `nso_data()`:
      ! `tbl_id` must be a non-empty table identifier.

# metadata and manifest validation errors name the user-facing function

    Code
      nso_metadata("bogus", 1)
    Condition
      Error in `nso_metadata()`:
      ! `type` must be one of: database, table, indicator, classification, or form.

---

    Code
      nso_metadata("database", -1)
    Condition
      Error in `nso_metadata()`:
      ! `id` must be a positive integer metadata identifier.

---

    Code
      nso_forms(1, include_raw = NA)
    Condition
      Error in `nso_forms()`:
      ! `include_raw` must be TRUE or FALSE.

---

    Code
      nso_read_manifest(NA_character_)
    Condition
      Error in `nso_read_manifest()`:
      ! `path` must be a single non-empty file path.

