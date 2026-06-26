# Presentations

Static host for every Kap Chatfield presentation. Lives at **presentations.kapchatfield.com**.

## Add a new presentation (3 steps)

1. **Make a folder.** Name it with the URL you want, all lowercase, words separated by hyphens. Example: `daniel-in-babylon`. Put your deck inside it as `index.html`.

   ```
   daniel-in-babylon/
     index.html
   ```

2. **Add one entry to `presentations.json`** so it shows on the gallery:

   ```json
   {
     "slug": "daniel-in-babylon",
     "title": "Daniel in Babylon",
     "description": "One line on what the deck is.",
     "date": "2026-06-25",
     "tag": "Kap Chat"
   }
   ```

   `slug` must match the folder name exactly. `date` controls the order (newest first). `tag` and `description` are optional.

3. **Push** (GitHub Desktop: Commit, then Push origin). Vercel redeploys in about 30 seconds. The deck is live at `presentations.kapchatfield.com/daniel-in-babylon`.

That's it. The folder is the URL. The JSON entry is the gallery card.

## Files

- `index.html` — the auto-gallery. Reads `presentations.json` and lists every deck. Don't rename it.
- `presentations.json` — the list that powers the gallery. Edit this every time you add a deck.
- `sample-presentation/` — example slot. Delete it once you have a real deck (and remove its line from the JSON).

See `SETUP.md` for the one-time GitHub + Vercel + domain setup.
