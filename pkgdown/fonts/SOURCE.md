# Source Sans 3 web fonts

Original, unmodified Adobe Source Sans 3 version 3.052, release tag `3.052R`.
Downloaded from the official repository on 2026-11-01.

- Repository: https://github.com/adobe-fonts/source-sans
- Release: https://github.com/adobe-fonts/source-sans/releases/tag/3.052R
- Pinned release commit: `ed1808970eb3c7301c9a523bee26473ba0bb62fa`
- Upstream release branch at verification: `87b37a2daaed80fcb8e8ccb0085c4d72ddade12e`
- License: SIL Open Font License 1.1; original `LICENSE.md` is included here.

The release and commit were verified with `gh api`. Files retain their original
names and full glyph repertoire, including Mongolian Cyrillic Ө Ү ө ү й.
They have not been subset, renamed, converted, or otherwise modified.

| Upstream path | Git blob SHA-1 |
| --- | --- |
| WOFF2/OTF/SourceSans3-Regular.otf.woff2 | 47c936f4686bb3fe1c08fbaeee6f43d4fac3a73e |
| WOFF2/OTF/SourceSans3-Bold.otf.woff2 | 24e997292756d5adb3790992dd9b1ef6c5a14ce7 |

Matching OTF files are bundled in `inst/fonts/` for R/systemfonts registration.
`tools/plot_fonts.R` embeds these complete WOFF2 files as data URIs inside plot
SVGs, allowing the intended fonts to load when a browser displays SVGs as images.
