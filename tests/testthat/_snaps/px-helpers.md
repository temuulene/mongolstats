# .px_resolve_table warns on ambiguous table id and uses first match

    Code
      result <- .px_resolve_table("DT_TEST", idx = fake_idx)
    Condition
      Warning:
      Table id "DT_TEST" matches 2 different tables in the PXWeb catalogue.
      i Using the first match, in folder "sector/sub": First table.
      i Ignored match in folder: "other/place".

