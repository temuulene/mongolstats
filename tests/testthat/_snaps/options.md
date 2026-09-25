# nso_options() rejects invalid values without changing options

    Code
      nso_options(mongolstats.lang = "fr")
    Condition
      Error in `nso_options()`:
      ! mongolstats.lang must be one of "en" or "mn", not "fr".

---

    Code
      nso_options(mongolstats.default_labels = "english")
    Condition
      Error in `nso_options()`:
      ! mongolstats.default_labels must be one of "none", "code", "en", "mn", or "both", not "english".

---

    Code
      nso_options(mongolstats.timeout = -1)
    Condition
      Error in `nso_options()`:
      ! mongolstats.timeout must be a single positive number (seconds), not -1.

---

    Code
      nso_options(mongolstats.retry_tries = 0)
    Condition
      Error in `nso_options()`:
      ! mongolstats.retry_tries must be a single positive whole number, not 0.

---

    Code
      nso_options(mongolstats.offline = "yes")
    Condition
      Error in `nso_options()`:
      ! mongolstats.offline must be `TRUE` or `FALSE`, not "yes".

# nso_options() warns about unknown option names

    Code
      old <- nso_options(mongolstats.langauge = "mn")
    Condition
      Warning:
      "mongolstats.langauge" is not a mongolstats option; set anyway.
      i Known options: "mongolstats.px_base_url", "mongolstats.lang", "mongolstats.px_db", "mongolstats.timeout", "mongolstats.retry_tries", "mongolstats.retry_backoff", "mongolstats.verbose", "mongolstats.offline", "mongolstats.default_labels", "mongolstats.progress", "mongolstats.parallel", "mongolstats.value_name", and "mongolstats.attach_raw".

# .px_lang() errors on an unsupported language set via options()

    Code
      .px_lang()
    Condition
      Error in `.px_lang()`:
      ! mongolstats.lang must be one of "en" or "mn", not "fr".

