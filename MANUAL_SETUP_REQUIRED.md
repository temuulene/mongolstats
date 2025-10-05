# Manual Setup Required for sf Package

The `sf` package (spatial features for R) requires system libraries that need sudo access to install.

## Step 1: Install System Dependencies

Run these commands in your WSL terminal (you'll be prompted for your password):

```bash
sudo apt update
sudo apt install -y libgdal-dev libgeos-dev libproj-dev libudunits2-dev
```

## Step 2: Install sf Package in R

After the system libraries are installed:

```bash
cd "/mnt/c/Users/Temuulen/My Drive (temuulen@gmail.com)/r-related/mng-nso-stats"
Rscript -e "install.packages('sf', repos = 'https://cloud.r-project.org')"
```

## Step 3: Continue with Verification

Once `sf` is installed, continue with the verification steps from REBUILD_INSTRUCTIONS.md:

```bash
# Step 1: Generate documentation
Rscript -e "roxygen2::roxygenise()"

# Step 2: Run R CMD check
Rscript -e "rcmdcheck::rcmdcheck(args = c('--no-manual', '--as-cran'), error_on = 'warning')"

# Step 3: Run integration tests
Rscript -e "devtools::test()"

# Step 4: Build pkgdown site
Rscript -e "pkgdown::build_site(preview = FALSE, install = FALSE)"
```

## Why sf Needs System Libraries

The `sf` package wraps several geospatial C++ libraries:
- **GDAL** (Geospatial Data Abstraction Library): Read/write spatial data formats
- **GEOS** (Geometry Engine Open Source): Spatial operations
- **PROJ**: Coordinate reference system transformations
- **udunits2**: Units of measurement handling

These must be installed at the system level before R can compile the sf package.

## Alternative: Skip sf-dependent Features

If you only want to test the PXWeb API functionality (without spatial features), you could temporarily comment out the `sf` import in the DESCRIPTION file. However, this would disable:
- `mn_boundaries()` - Download administrative boundaries
- `mn_join_by_name()` - Join data to boundaries
- `mn_fuzzy_join_by_name()` - Fuzzy boundary joins
- All mapping vignettes

## Troubleshooting

If `sf` installation still fails after installing system libraries, check:

```bash
# Verify GDAL is installed
gdal-config --version

# Verify GEOS is installed
geos-config --version

# Verify PROJ is installed
pkg-config --modversion proj
```

If any of these commands fail, the corresponding library didn't install correctly.
