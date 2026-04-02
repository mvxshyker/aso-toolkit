#!/usr/bin/env bash
# Fetch app metadata from iTunes Search API
# Usage: ./fetch-app-data.sh <app-id-or-url>
#
# Returns JSON with app metadata. Called by workflows via:
#   > script: scripts/fetch-app-data.sh

set -euo pipefail

INPUT="$1"

# Extract numeric ID from various input formats
if [[ "$INPUT" =~ ^[0-9]+$ ]]; then
    APP_ID="$INPUT"
elif [[ "$INPUT" =~ id([0-9]+) ]]; then
    APP_ID="${BASH_REMATCH[1]}"
elif [[ "$INPUT" =~ apps\.apple\.com/.*/app/.*/id([0-9]+) ]]; then
    APP_ID="${BASH_REMATCH[1]}"
else
    echo "Error: Could not extract numeric App ID from: $INPUT" >&2
    exit 1
fi

# Fetch from iTunes Search API (no auth required)
curl -s "https://itunes.apple.com/lookup?id=${APP_ID}" | python3 -m json.tool 2>/dev/null || \
curl -s "https://itunes.apple.com/lookup?id=${APP_ID}"
