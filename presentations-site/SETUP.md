# One-time setup

You do this once. After that, adding a deck is the 3 steps in `README.md`.

Total time: about 15 minutes. You need a GitHub account, a Vercel account (free, sign in with GitHub), and access to wherever kapchatfield.com's DNS is managed.

---

## Step 1 — Put this folder on GitHub

1. Download and install **GitHub Desktop** (desktop.github.com). Sign in with your GitHub account.
2. In GitHub Desktop: **File → Add Local Repository**, then choose this `presentations-site` folder. It will say the folder isn't a repository yet and offer to **create a repository** — click that.
3. Name it `presentations`. Leave it private or public, your call. Click **Create Repository**.
4. Click **Publish repository** (top bar) to push it up to GitHub.

You now have a `presentations` repo on GitHub. This is your permanent archive.

---

## Step 2 — Connect it to Vercel

1. Go to **vercel.com** and **Sign in with GitHub**.
2. Click **Add New → Project**.
3. Find the `presentations` repo in the list and click **Import**.
4. Don't change any build settings. It's plain HTML, so Framework Preset = **Other**, and leave build/output fields empty. Click **Deploy**.
5. Wait ~30 seconds. Vercel gives you a live URL like `presentations-xxxx.vercel.app`. Open it — you should see the gallery.

---

## Step 3 — Point your subdomain at it

1. In the Vercel project, go to **Settings → Domains**.
2. Type `presentations.kapchatfield.com` and click **Add**.
3. Vercel shows you a DNS record to create. It will be a **CNAME**:
   - **Type:** CNAME
   - **Name / Host:** `presentations`
   - **Value / Target:** `cname.vercel-dns.com`
4. Go to wherever kapchatfield.com's DNS lives (your domain registrar or DNS host — e.g. GoDaddy, Cloudflare, Namecheap) and add exactly that record.
5. Back in Vercel, it will verify automatically. This can take a few minutes up to a couple hours, but is usually fast.

When it's verified, **presentations.kapchatfield.com** is live, with HTTPS handled for you automatically.

---

## After setup

Every push to the `presentations` repo redeploys the site automatically. You never touch Vercel again. To add a deck, follow the 3 steps in `README.md`.

## Why not Railway?

Railway runs backend apps, databases, and always-on services. Static HTML files don't need any of that, and Railway would cost money to keep a server running for something Vercel serves for free. Keep Railway for FishFlow automations and anything with a real backend. This site belongs on Vercel.
