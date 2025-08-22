#!/usr/bin/env bash
#
# generate-local-themes.sh
# Prepares Grunt configs and generates local-themes.js for Magento 2 themes.
#

set -euo pipefail

# Check if running in Magento root directory and exists themes
if [ ! -d "app/design/frontend" ]; then
  echo "❌ This script must be run from the Magento root directory."
  exit 1
fi

# --- Step 1: Prepare Grunt config files ---
mv -n package.json.sample package.json 2>/dev/null || true
mv -n Gruntfile.js.sample Gruntfile.js 2>/dev/null || true
mv -n grunt-config.json.sample grunt-config.json 2>/dev/null || true
npm install --no-audit --no-fund --prefer-offline --legacy-peer-deps 2>/dev/null || true

# --- Step 2: Generate local-themes.js ---
THEMES_DIR="app/design/frontend"
OUTPUT_FILE="dev/tools/grunt/configs/local-themes.js"

# Ensure jq exists
if ! command -v jq >/dev/null 2>&1; then
  echo "❌ jq is required but not installed."
  exit 1
fi

# Default file sets by base themes
declare -A BASE_FILES
BASE_FILES["Magento/blank"]='["css/styles-m","css/styles-l","css/email","css/email-inline"]'
BASE_FILES["Magento/luma"]='["css/styles-m","css/styles-l"]'
BASE_FILES["Magento/backend"]='["css/styles-old","css/styles"]'

# Start empty JSON object
themes_json="{}"

# Function: detect parent theme from theme.xml
get_parent_theme() {
  local theme_path="$1"
  if [ -f "$theme_path/theme.xml" ]; then
    grep -oPm1 "(?<=<parent>)[^<]+" "$theme_path/theme.xml" || true
  fi
}

# Loop through vendors and themes
for vendor in "$THEMES_DIR"/*; do
  [ -d "$vendor" ] || continue
  vendor_name=$(basename "$vendor")

  for theme in "$vendor"/*; do
    [ -d "$theme" ] || continue
    theme_name=$(basename "$theme")

    theme_code="${theme_name}"                 # used as key
    theme_full="${vendor_name}/${theme_name}"  # used as name
    normalized_name=$(echo "$theme_name" | tr '[:upper:]' '[:lower:]')

    # Detect parent theme (if any)
    parent_theme=$(get_parent_theme "$theme")

    # Pick files list based on parent or fallback
    if [ -n "$parent_theme" ] && [ -n "${BASE_FILES[$parent_theme]+x}" ]; then
      files_json="${BASE_FILES[$parent_theme]}"
    else
      files_json='["css/styles-m","css/styles-l"]'
    fi

    # Construct theme JSON using jq
    themes_json=$(jq \
      --arg theme_key "$normalized_name" \
      --arg theme "$theme_code" \
      --arg area "frontend" \
      --arg name "$theme_full" \
      --arg locale "en_US" \
      --argjson files "$files_json" \
      '. + {($theme_key): {area: $area, name: $name, locale: $locale, files: $files, dsl: "less"}}' \
      <<< "$themes_json")
  done
done

# Add backend theme explicitly if desired
themes_json=$(jq \
  --arg theme "backend" \
  --arg area "adminhtml" \
  --arg name "Magento/backend" \
  --arg locale "en_US" \
  --argjson files "${BASE_FILES["Magento/backend"]}" \
  '. + {($theme): {area: $area, name: $name, locale: $locale, files: $files, dsl: "less"}}' \
  <<< "$themes_json")

# Write to local-themes.js in JS module format
mkdir -p "$(dirname "$OUTPUT_FILE")"
{
  echo "module.exports ="
  echo "$themes_json" | jq .
  echo ";"
} > "$OUTPUT_FILE"

echo "✅ Generated $OUTPUT_FILE"
