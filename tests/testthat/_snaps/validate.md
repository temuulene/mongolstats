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

