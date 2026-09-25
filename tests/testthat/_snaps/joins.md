# join helpers error clearly on a missing name column

    Code
      mn_join_by_name(d, "region")
    Condition
      Error in `mn_join_by_name()`:
      ! Column "region" not found in `data`.
      i Available columns: "aimag" and "pop".

---

    Code
      mn_fuzzy_join_by_name(d, "region")
    Condition
      Error in `mn_fuzzy_join_by_name()`:
      ! Column "region" not found in `data`.
      i Available columns: "aimag" and "pop".

---

    Code
      mn_join_by_name(d, c("a", "b"))
    Condition
      Error in `mn_join_by_name()`:
      ! `name_col` must be a single character string.

# fuzzy join rejects edit-distance thresholds for method = 'jw'

    Code
      mn_fuzzy_join_by_name(d, "aimag", boundaries = fake_boundaries(), method = "jw")
    Condition
      Error in `mn_fuzzy_join_by_name()`:
      ! `max_distance` must be below 1 for `method = "jw"`.
      i Jaro-Winkler distances lie between 0 and 1, so 2 would match every name.
      i Try `max_distance = 0.2`.

# fuzzy join validates max_distance

    Code
      mn_fuzzy_join_by_name(d, "aimag", boundaries = fake_boundaries(), max_distance = -
      1)
    Condition
      Error in `mn_fuzzy_join_by_name()`:
      ! `max_distance` must be a single non-negative number.

# joins warn about data names that match no boundary

    Code
      res <- mn_join_by_name(d, "aimag", boundaries = fake_boundaries())
    Condition
      Warning:
      1 name in `data` matched no boundary and was dropped: "Ulan Bator".
      i Check the spelling, or use `mn_fuzzy_join_by_name()`.

