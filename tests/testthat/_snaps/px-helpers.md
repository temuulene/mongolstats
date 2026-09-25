# .px_resolve_table warns on ambiguous table id and uses first match

    Code
      result <- .px_resolve_table("DT_TEST", idx = fake_idx)
    Condition
      Warning:
      Table id "DT_TEST" matches 2 different tables in the PXWeb catalogue.
      i Using the first match, in folder "sector/sub": First table.
      i Ignored match in folder: "other/place".

# .px_flatten_response errors on keys that do not match the columns

    Code
      .px_flatten_response(out)
    Condition
      Error in `.px_flatten_response()`:
      ! Malformed PXWeb response: row 2 has 1 key, expected 2.
      i Dimension columns: "A" and "B".

