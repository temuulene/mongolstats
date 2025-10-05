# mongolstats (development version)

## mongolstats 0.0.0.9000

### Major improvements

* Package upgraded to follow 2024-2025 R package development best practices
* Fixed pkgdown site to properly display all vignettes
* Added VignetteBuilder to DESCRIPTION for proper vignette building
* Renamed primary vignette from `getting-started` to `mongolstats` for automatic "Get Started" link
* Updated all vignette titles from "tidy1212" to "mongolstats"

### Infrastructure

* Updated pkgdown configuration with correct URLs and navbar structure
* Enhanced CI/CD workflow to set PKGDOWN_EVAL environment variable
* Added lifecycle badges to README (package is experimental)
* Added MIT license badge
* Improved .Rbuildignore to allow vignettes while excluding build artifacts
* Added NEWS.md for version tracking

### Documentation

* All documentation now uses consistent "mongolstats" branding
* pkgdown site will now show all 4 vignettes as articles
* Improved README with properly linked badges

### Bug fixes

* Fixed vignette exclusion in .Rbuildignore that prevented vignettes from building
* Updated vignettes/.gitignore to only exclude generated files, not source .Rmd files
