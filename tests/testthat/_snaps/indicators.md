# indicator validation errors name the user-facing function

    Code
      nso_indicator(NA)
    Condition
      Error in `nso_indicator()`:
      ! `id` must be a single valid source identifier or parameter.

---

    Code
      nso_indicators(refresh = NA)
    Condition
      Error in `nso_indicators()`:
      ! `refresh` must be TRUE or FALSE.

---

    Code
      nso_indicator_query("gdp_current", periods = NA_character_)
    Condition
      Error in `nso_indicator_query()`:
      ! `periods` must be NULL or nonmissing source period labels.

