# catalogue crawl warns when parts of the catalogue fail

    Code
      idx <- nso_px_tables()
    Condition
      Warning:
      1 catalogue request failed; the table index is incomplete.
      i Failed: "A".

# nso_dim_values() explains unknown and ambiguous dimensions

    Code
      nso_dim_values("T", "Region")
    Condition
      Error in `nso_dim_values()`:
      ! Dimension "Region" not found in table "T".
      i Available dimensions: "Sex", "Year", and "Age group".

---

    Code
      nso_dim_values("T", "e")
    Condition
      Error in `nso_dim_values()`:
      ! Dimension "e" is ambiguous in table "T".
      i Candidates: "Sex", "Year", and "Age group".

---

    Code
      nso_dim_values("T", c("Sex", "Year"))
    Condition
      Error in `nso_dim_values()`:
      ! `dim` must be a single character string.

# nso_subsectors() splits a path id into PXWeb path segments

    Code
      nso_subsectors(c("a", "b"))
    Condition
      Error in `nso_subsectors()`:
      ! `subid` must be a single character string.

