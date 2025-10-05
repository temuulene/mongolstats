# Installing R in WSL Ubuntu 24.04

## Quick Installation (Recommended)

Run these commands in your WSL terminal:

```bash
# Update package list
sudo apt update

# Install R base
sudo apt install -y r-base r-base-dev

# Install common dependencies for R packages
sudo apt install -y \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  libfontconfig1-dev \
  libharfbuzz-dev \
  libfribidi-dev \
  libfreetype6-dev \
  libpng-dev \
  libtiff5-dev \
  libjpeg-dev \
  libgit2-dev
```

## Install Required R Packages

After R is installed, run R and install the needed packages:

```bash
# Start R
R

# In R console, run:
install.packages(c(
  "devtools",
  "roxygen2",
  "rcmdcheck",
  "pkgdown",
  "testthat",
  "remotes"
), repos = "https://cloud.r-project.org")

# Install package dependencies
devtools::install_dev_deps()

# Exit R
q()
```

## Verify Installation

```bash
# Check R version
R --version

# Check Rscript
Rscript --version
```

You should see R version 4.x.x installed.

## Alternative: Use CRAN Repository for Latest R

If you want the absolute latest version of R:

```bash
# Add CRAN repository
sudo apt install -y software-properties-common dirmngr
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marullus.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc

# Add repository
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

# Update and install
sudo apt update
sudo apt install -y r-base r-base-dev
```

## After Installation

Once R is installed, you can run the verification commands:

```bash
cd "/mnt/c/Users/Temuulen/My Drive (temuulen@gmail.com)/r-related/mng-nso-stats"

# Generate documentation
Rscript -e "roxygen2::roxygenise()"

# Run R CMD check
Rscript -e "rcmdcheck::rcmdcheck(args = c('--no-manual', '--as-cran'), error_on = 'warning')"

# Run integration tests
Rscript -e "devtools::test()"

# Build pkgdown site
Rscript -e "pkgdown::build_site()"
```

## Troubleshooting

### If installation fails due to missing dependencies:

```bash
sudo apt install -y build-essential gfortran
```

### If libcurl error occurs:

```bash
sudo apt install -y libcurl4-openssl-dev
```

### If xml2 package fails to install:

```bash
sudo apt install -y libxml2-dev
```

### If git2r package fails:

```bash
sudo apt install -y libgit2-dev
```

## Memory Considerations

Building packages and documentation can be memory-intensive. If you encounter memory issues:

1. Close other applications
2. Increase WSL memory limit in `.wslconfig`:

```
# In Windows: C:\Users\Temuulen\.wslconfig
[wsl2]
memory=4GB
processors=2
```

3. Restart WSL: `wsl --shutdown` in PowerShell, then reopen

## Using RStudio in WSL

Alternatively, you can install RStudio Server in WSL:

```bash
# Install RStudio Server
sudo apt install -y gdebi-core
wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2024.04.2-764-amd64.deb
sudo gdebi rstudio-server-2024.04.2-764-amd64.deb

# Start RStudio Server
sudo rstudio-server start

# Access at: http://localhost:8787
# Login with your WSL username and password
```
