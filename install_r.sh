#!/bin/bash
# Quick R installation script for WSL Ubuntu 24.04

set -e

echo "=========================================="
echo "Installing R and dependencies in WSL"
echo "=========================================="

# Update package list
echo "Updating package list..."
sudo apt update

# Install R base
echo "Installing R base..."
sudo apt install -y r-base r-base-dev

# Install system dependencies for R packages
echo "Installing system dependencies..."
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
  libgit2-dev \
  build-essential \
  gfortran

# Verify installation
echo ""
echo "=========================================="
echo "R Installation Complete!"
echo "=========================================="
R --version

echo ""
echo "Next steps:"
echo "1. Install R packages by running:"
echo "   Rscript install_r_packages.R"
echo ""
echo "2. Or manually in R:"
echo "   R"
echo "   install.packages(c('devtools', 'roxygen2', 'rcmdcheck', 'pkgdown'))"
echo ""
