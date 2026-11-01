# Mongolian documentation

`pkgdown/build-mn.R` mirrors every freshly rendered English HTML page and its
assets under `docs/mn`. One analysis generates both language versions. The
translation step changes prose, navigation, accessible descriptions, comments,
search text and vector figure labels. Executable R, API identifiers, official
selection strings and verbatim console output remain reproducible.

`translations.jsonl` contains one record per reusable source template: `id`,
`source`, and `target`. The key is the first 20 characters of the template's
SHA-256 digest. Numeric values, inline code, links and formatting are represented
by numbered placeholders. Keep every placeholder exactly once in the translated
text; reorder complete formatting pairs only when needed for Mongolian grammar.
Numbers are inserted from the same rendered English result after translation.

Run `Rscript tools/render_site.R` with the website dependencies installed. The
build writes `docs/translation-source.json`. Missing entries appear in the job
log as `I18N_SOURCE` JSON records and stop publication. Add faithful Mongolian
targets for those records, then rebuild. New source text cannot silently fall
back to English. Exact period values are protected, so routine data updates do
not require translating numbers again.

Website figures use svglite. Translated labels are fitted to their available
space; plot marks, coordinates, reference lines and numerical values are retained.
Review long captions and legends visually after a translation change.

`tools/check_site.R` checks matching page coverage, `lang=mn`, paired language
alternates, figures and local links. The translated search index is rebuilt from
Mongolian prose. Every page links to its English counterpart.

Run `testthat::test_dir("pkgdown/tests", stop_on_failure = TRUE)` for translation,
rendering and link-regression checks. Full site rendering requires the live NSO
services; unit checks use local fixtures.
