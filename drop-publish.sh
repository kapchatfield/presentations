#!/usr/bin/env bash
#
# drop-publish.sh — wrapper used by the "Publish Presentation" drag-and-drop app.
#
# Usage:
#   drop-publish.sh "/path/to/deck.html" "<Title>" "<tag>"
#
# Derives a URL-safe slug from the Title, then hands off to publish.sh.
# Kept separate from publish.sh so the slug logic is testable on its own.
#
set -euo pipefail

# Make sure Homebrew tools (python3, gh) and system git are findable even when
# launched from a GUI app, which starts with a minimal PATH.
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$#" -ne 3 ]; then
  echo "Usage: drop-publish.sh \"/path/to/deck.html\" \"<Title>\" \"<tag>\"" >&2
  exit 1
fi

DECK="$1"
TITLE="$2"
TAG="$3"

# Derive slug from the title: lowercase, non-alphanumerics -> hyphens,
# collapse repeats, trim leading/trailing hyphens.
SLUG="$(printf '%s' "$TITLE" \
  | tr '[:upper:]' '[:lower:]' \
  | sed -E 's/[^a-z0-9]+/-/g; s/-+/-/g; s/^-//; s/-$//')"

if [ -z "$SLUG" ]; then
  echo "Error: could not derive a slug from title '$TITLE'." >&2
  exit 1
fi

echo "Slug: $SLUG"
exec "$ROOT/publish.sh" "$SLUG" "$TITLE" "$TAG" "$DECK"
