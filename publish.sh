#!/usr/bin/env bash
#
# publish.sh — add a new presentation to the gallery and deploy it.
#
# Usage:
#   ./publish.sh <slug> "<Title>" "<tag>" /path/to/deck.html
#
# Example:
#   ./publish.sh q3-keynote "Q3 Keynote" "Keynote" ~/Desktop/q3.html
#
# What it does:
#   1. Copies your deck HTML to presentations-site/<slug>/index.html
#   2. Adds a matching entry to presentations-site/presentations.json
#      (slug, title, description placeholder, today's date, tag)
#   3. git add + commit + push to main, so Vercel auto-redeploys.
#
set -euo pipefail

# Resolve the repo root (directory this script lives in) so it works from anywhere.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SITE="$ROOT/presentations-site"
MANIFEST="$SITE/presentations.json"

# --- Validate arguments ---------------------------------------------------
if [ "$#" -ne 4 ]; then
  echo "Usage: ./publish.sh <slug> \"<Title>\" \"<tag>\" /path/to/deck.html" >&2
  exit 1
fi

SLUG="$1"
TITLE="$2"
TAG="$3"
DECK="$4"

# Slug must be URL-safe (lowercase letters, numbers, hyphens) since it becomes the folder/URL.
if ! [[ "$SLUG" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "Error: slug must be lowercase letters, numbers, and hyphens only (got '$SLUG')." >&2
  exit 1
fi

if [ ! -f "$DECK" ]; then
  echo "Error: deck file not found: $DECK" >&2
  exit 1
fi

if [ ! -f "$MANIFEST" ]; then
  echo "Error: manifest not found: $MANIFEST" >&2
  exit 1
fi

DEST_DIR="$SITE/$SLUG"
if [ -d "$DEST_DIR" ]; then
  echo "Note: '$SLUG' already exists — overwriting its index.html." >&2
fi

TODAY="$(date +%F)"   # YYYY-MM-DD

# --- 1. Copy the deck into its slug folder --------------------------------
mkdir -p "$DEST_DIR"
cp "$DECK" "$DEST_DIR/index.html"
echo "✓ Wrote $DEST_DIR/index.html"

# --- 2. Add (or replace) the manifest entry -------------------------------
SLUG="$SLUG" TITLE="$TITLE" TAG="$TAG" TODAY="$TODAY" python3 - "$MANIFEST" <<'PY'
import json, os, sys

manifest = sys.argv[1]
slug  = os.environ["SLUG"]
title = os.environ["TITLE"]
tag   = os.environ["TAG"]
today = os.environ["TODAY"]

with open(manifest) as f:
    data = json.load(f)

entry = {
    "slug": slug,
    "title": title,
    "description": "Add a description for this deck.",
    "date": today,
    "tag": tag,
}

# Replace an existing entry with the same slug, otherwise prepend (newest first).
data = [d for d in data if d.get("slug") != slug]
data.insert(0, entry)

with open(manifest, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY
echo "✓ Updated presentations.json"

# --- 3. Commit and push ---------------------------------------------------
cd "$ROOT"
git add "presentations-site/$SLUG/index.html" "presentations-site/presentations.json"
git commit -m "Add presentation: $TITLE ($SLUG)"
git push origin main

echo
echo "✓ Pushed to main — Vercel will redeploy shortly."
echo "  Live in ~1 min at: https://presentations.kapchatfield.com/$SLUG/"
echo "  Tip: edit the description for '$SLUG' in presentations-site/presentations.json."
