# presentations

Source for **presentations.kapchatfield.com** — a static, manifest-driven gallery
of presentation decks, deployed on Vercel.

## How it works

- The live site is built from the [`presentations-site/`](presentations-site/) folder.
  Vercel's project **Root Directory** is set to `presentations-site`, so everything
  the site serves must live under that folder. **Don't move files to the repo root** —
  the live site will 404.
- [`presentations-site/index.html`](presentations-site/index.html) is the gallery. It
  reads [`presentations-site/presentations.json`](presentations-site/presentations.json)
  at load time and renders a card for every deck.
- Each deck is its own folder under `presentations-site/`, containing an `index.html`.
  **The folder name is the URL slug** — e.g. `presentations-site/q3-keynote/index.html`
  is served at `https://presentations.kapchatfield.com/q3-keynote/`.
- Every push to `main` triggers an automatic Vercel redeploy.

## Add a presentation — drag and drop (easiest)

There's a Mac app called **Publish Presentation** (on the Desktop). Drag any
presentation `.html` file onto its icon. It asks for a title and a tag, then
publishes and pushes automatically — the deck is live in about a minute. No
Terminal needed.

The app is a thin wrapper around the scripts below. Its source is
[`publish-app.applescript`](publish-app.applescript); rebuild it any time with:

```bash
osacompile -o ~/Desktop/"Publish Presentation.app" publish-app.applescript
```

First launch only: macOS may warn it's from an unidentified developer — right-click
the app → **Open** → **Open** to allow it. After that, plain drag-and-drop works.

## Add a presentation — with the script (recommended)

From the repo root:

```bash
./publish.sh <slug> "<Title>" "<tag>" /path/to/deck.html
```

Example:

```bash
./publish.sh q3-keynote "Q3 Keynote" "Keynote" ~/Desktop/q3.html
```

The script will:

1. Copy your deck to `presentations-site/<slug>/index.html`.
2. Add an entry to `presentations.json` (slug, title, a placeholder description,
   today's date, and your tag) — newest first.
3. `git add`, `commit`, and `push` to `main` so Vercel redeploys.

After it runs, the deck is live at `https://presentations.kapchatfield.com/<slug>/`
in about a minute. Edit the placeholder **description** for the new entry in
`presentations.json` whenever you like (then commit + push, or just rerun the script).

**Slug rules:** lowercase letters, numbers, and hyphens only (it becomes the URL).

> First run? Make the script executable once: `chmod +x publish.sh`

## Add a presentation — manually

1. Create the folder and deck:
   `presentations-site/<slug>/index.html` (your standalone deck HTML).
2. Add an entry to `presentations-site/presentations.json`:

   ```json
   {
     "slug": "<slug>",
     "title": "<Title>",
     "description": "One line about the deck.",
     "date": "2026-06-26",
     "tag": "<tag>"
   }
   ```

   Entries are listed in array order (newest first is the convention).
3. Commit and push:

   ```bash
   git add presentations-site/
   git commit -m "Add presentation: <Title>"
   git push origin main
   ```

Vercel redeploys automatically on push to `main`.

## Brand

Black background, white text, lavender `#8D82FE` accent only, Helvetica Neue Bold
headers. No gold, no other fonts. Keep new decks and the gallery consistent.
