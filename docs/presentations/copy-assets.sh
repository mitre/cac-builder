#!/usr/bin/env bash
# Script to copy assets to public directory for Slidev

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_DIR="$SCRIPT_DIR/assets"
PUBLIC_DIR="$SCRIPT_DIR/public"

# Create directories if they don't exist
mkdir -p "$ASSETS_DIR"
mkdir -p "$PUBLIC_DIR/assets"

# Create a basic container diagram if it doesn't exist
CONTAINER_DIAGRAM="$ASSETS_DIR/container-diagram.png"
if [ ! -f "$CONTAINER_DIAGRAM" ] || [ ! -s "$CONTAINER_DIAGRAM" ]; then
    echo "Creating container diagram..."
    
    # Try to generate a simple Docker logo as SVG first
    cat > "$ASSETS_DIR/container-diagram.svg" << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="300" height="200" viewBox="0 0 300 200">
  <rect x="50" y="30" width="200" height="140" fill="#066da5" rx="10" />
  <text x="150" y="100" font-family="Arial" font-size="18" text-anchor="middle" fill="white">CAC-Builder</text>
  <text x="150" y="130" font-family="Arial" font-size="14" text-anchor="middle" fill="white">Container Environment</text>
  <rect x="60" y="40" width="30" height="30" fill="white" opacity="0.2" />
  <rect x="100" y="40" width="30" height="30" fill="white" opacity="0.2" />
  <rect x="140" y="40" width="30" height="30" fill="white" opacity="0.2" />
  <rect x="60" y="80" width="30" height="30" fill="white" opacity="0.2" />
  <rect x="100" y="80" width="30" height="30" fill="white" opacity="0.2" />
</svg>
EOF

    # Try to convert SVG to PNG using various methods
    if command -v convert > /dev/null; then
        echo "Converting SVG to PNG using ImageMagick..."
        convert "$ASSETS_DIR/container-diagram.svg" "$CONTAINER_DIAGRAM"
    elif command -v rsvg-convert > /dev/null; then
        echo "Converting SVG to PNG using rsvg-convert..."
        rsvg-convert -o "$CONTAINER_DIAGRAM" "$ASSETS_DIR/container-diagram.svg"
    else
        # If conversion tools are not available, create a basic PNG
        echo "Creating a fallback PNG image..."
        # Base64-encoded 1x1 blue pixel PNG
        echo "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M/wHwAEBgIApD5fRAAAAABJRU5ErkJggg==" | base64 -d > "$CONTAINER_DIAGRAM"
        
        # Note for the user
        echo "WARNING: Could not create a proper container diagram."
        echo "Install ImageMagick or librsvg for better image conversion."
    fi
fi

# Make sure the public directory exists
mkdir -p "$PUBLIC_DIR/assets"

# Copy the assets to the public directory
echo "Copying assets to public directory..."
cp -r "$ASSETS_DIR"/* "$PUBLIC_DIR/assets/" || true

echo "Assets prepared for Slidev!"
