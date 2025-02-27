#!/usr/bin/env bash
# Script to manually fix common Slidev presentation issues

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_DIR="$SCRIPT_DIR/assets"
PUBLIC_DIR="$SCRIPT_DIR/public"

echo "Creating required directories..."
mkdir -p "$ASSETS_DIR"
mkdir -p "$PUBLIC_DIR/assets"

echo "Fixing container diagram..."
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

echo "Copying SVG directly to public assets..."
cp "$ASSETS_DIR/container-diagram.svg" "$PUBLIC_DIR/assets/"

echo "Updating presentation file to use SVG instead of PNG..."
sed -i '' 's/container-diagram\.png/container-diagram.svg/g' "$SCRIPT_DIR/cac-builder-intro.md"

echo "Manual fix complete! Try running the presentation now."
