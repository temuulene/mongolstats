# a table that moved folder is found by walking the catalogue

    Code
      tm <- .px_table_meta("T1")
    Message
      i Table "T1" is no longer in folder "A"; searching the NSO catalogue for it.
      i Table "T1" has moved to folder "A/B".
        Rebuild the table index with `nso_rebuild_px_index()` to refresh all locations.

# a withdrawn table errors once and is not searched for again

    Code
      .px_table_meta("T2")
    Message
      i Table "T2" is no longer in folder "Z"; searching the NSO catalogue for it.
    Condition
      Error:
      ! Table "T2" is no longer in folder "Z" and was not found elsewhere in the NSO catalogue.
      i It may have been withdrawn. Search for a replacement with `nso_search()`.
      Caused by error in `.px_meta_cached()`:
      ! gone

# an unknown table still errors when the search finds nothing

    Code
      .px_resolve_table("NOPE")
    Condition
      Error:
      ! Table "NOPE" not found in PXWeb index.
      i Find table ids with `nso_search()` or `nso_tables()`.

