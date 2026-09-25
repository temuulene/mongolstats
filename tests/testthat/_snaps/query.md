# nso_query rejects bad tbl_id

    Code
      nso_query(123)
    Condition
      Error in `nso_query()`:
      ! `tbl_id` must be a single character string, not a number.

---

    Code
      nso_query(c("a", "b"))
    Condition
      Error in `nso_query()`:
      ! `tbl_id` must be a single character string, not a character vector.

# nso_query rejects bad selections

    Code
      nso_query("DT_NSO_TEST", selections = "not_list")
    Condition
      Error in `nso_query()`:
      ! `selections` must be a named list of values.
      i Use `list(Year = "2023", Sex = "Total")`.

# print.nso_query summarises the query and returns it invisibly

    Code
      print(q)
    Output
      <nso_query>
        tbl_id    : DT_NSO_TEST
        selections: 2 dimensions
          - Year: 2018, 2019, 2020, ...
          - Sex: Total

# as_px_query and nso_fetch reject non-query input

    Code
      as_px_query("not_a_query")
    Condition
      Error in `as_px_query()`:
      ! `x` must be an <nso_query> object.

---

    Code
      nso_fetch("not_a_query")
    Condition
      Error in `nso_fetch()`:
      ! `x` must be an <nso_query> object.

