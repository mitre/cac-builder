#!/bin/bash
# Helper script to build specific ComplianceAsCode products

if [ $# -eq 0 ]; then
    echo "Usage: build-product [product-name]"
    echo "Example: build-product rhel9"
    echo ""
    echo "Available products:"
    ls -1 /content/products/
    exit 1
fi

PRODUCT=$1

# Clean previous build artifacts for this product
echo "Cleaning previous build for $PRODUCT..."
cd /content/build
rm -rf $PRODUCT

# Build the product
echo "Building $PRODUCT..."
make $PRODUCT -j$(nproc)

# Check build success
if [ $? -eq 0 ]; then
    echo "Build complete! Files available in /content/build/"

    # Copy output files to mounted volume
    echo "Copying files to output directory..."
    mkdir -p /output
    cp /content/build/ssg-$PRODUCT* /output/ 2>/dev/null || echo "No output files found"

    # List generated files
    echo "Generated files:"
    ls -la /content/build/ssg-$PRODUCT*

    echo "Files copied to host machine at ./output/"
else
    echo "Build failed for $PRODUCT"
    exit 1
fi
