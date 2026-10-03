# geoBoundaries helpers are deprecated in favour of mongolmaps

    Code
      j <- mn_join_by_name(d, "aimag", boundaries = b)
    Condition
      Warning:
      `mn_join_by_name()` was deprecated in mongolstats 0.3.0.
      i Please use `mongolmaps::mn_join()` instead.
      Warning:
      `mn_boundaries_normalize()` was deprecated in mongolstats 0.3.0.
      i Please use `mongolmaps::mn_match()` instead.
    Code
      j <- mn_fuzzy_join_by_name(d, "aimag", boundaries = b)
    Condition
      Warning:
      `mn_fuzzy_join_by_name()` was deprecated in mongolstats 0.3.0.
      i Please use `mongolmaps::mn_join()` instead.
      Warning:
      `mn_boundaries_normalize()` was deprecated in mongolstats 0.3.0.
      i Please use `mongolmaps::mn_match()` instead.
    Code
      g <- mn_boundaries_normalize(b)
    Condition
      Warning:
      `mn_boundaries_normalize()` was deprecated in mongolstats 0.3.0.
      i Please use `mongolmaps::mn_match()` instead.

# mn_boundaries() and mn_boundary_keys() are deprecated

    Code
      mn_boundaries("ADM0", refresh = TRUE)
    Condition
      Warning:
      `mn_boundaries()` was deprecated in mongolstats 0.3.0.
      i Please use `mongolmaps::mn_admin()` instead.
      Error in `.gb_gj_url()`:
      ! no network

---

    Code
      mn_boundary_keys("ADM0")
    Condition
      Warning:
      `mn_boundary_keys()` was deprecated in mongolstats 0.3.0.
      i Please use `mongolmaps::mn_codes()` instead.
      Warning:
      `mn_boundaries()` was deprecated in mongolstats 0.3.0.
      i Please use `mongolmaps::mn_admin()` instead.
      Error in `.gb_gj_url()`:
      ! no network

