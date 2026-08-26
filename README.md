# Health Triangle SMART Goal App — Health 1320

A private, self-contained goal-setting companion for Health Education I. Students take
a 36-question Health Triangle self-check (Physical / Mental & Emotional / Social), see a
tailored snapshot of strengths and growth areas mapped to the course modules, and build
SMART goals with lesson-aligned starters.

## Privacy / compliance (please read)

This app **collects nothing and transmits nothing.** It is a single static HTML file with
no backend, no database, and no analytics. Everything a student enters is kept **only in
that student's own browser** (`localStorage` on their device) so they can track goals across
the term; it is never sent to a server, to the teacher, or to anyone else. Students choose
whether to save, print, or hand in anything.

This design intentionally satisfies **Utah Code 53E-9-203**, which protects personal health
and behavior data even when anonymous: the activity is completable with **zero personal
disclosure at identical credit**. A hosted copy (GitHub Pages, Docker, Netlify, etc.) only
*serves the page* — hosting it does not collect student data. **Do not add any server-side
logging, form submission, or analytics that would capture student responses.**

## What's in this repo

| File | Purpose |
|------|---------|
| `index.html` | The entire app (open it in any browser to run it locally). |
| `Dockerfile` | Builds a small nginx image that serves the app. |
| `nginx.conf` | Server config: gzip, no-cache on the HTML, strict security headers. |
| `.github/workflows/docker-publish.yml` | CI: builds & pushes the image to Docker Hub. |
| `.github/workflows/deploy-pages.yml` | CI: publishes the app to GitHub Pages (optional). |

## Option A — Run the Docker container

Build and run locally:

```bash
docker build -t health-triangle-app .
docker run --rm -p 8080:80 health-triangle-app
# then open http://localhost:8080
```

Pull and run a published image (after CI has pushed it):

```bash
docker run --rm -p 8080:80 <your-dockerhub-username>/health-triangle-app:latest
```

The container is stateless — it just serves the static file — so it scales trivially and
needs no volumes or database.

## Option B — Publish the image to Docker Hub automatically

The `docker-publish.yml` workflow builds and pushes `<username>/health-triangle-app:latest`
on every push to `main`. Add two repository secrets first
(**Settings → Secrets and variables → Actions**):

- `DOCKERHUB_USERNAME` — your Docker Hub username
- `DOCKERHUB_TOKEN` — a Docker Hub **access token** (Docker Hub → Account settings → Personal access tokens)

## Option C — Free hosting with GitHub Pages (no Docker needed)

The `deploy-pages.yml` workflow publishes the app to
`https://<username>.github.io/<repo-name>/`. Turn it on once under
**Settings → Pages → Build and deployment → Source = GitHub Actions**.

## Updating the app

Replace `index.html` with the newer version and commit to `main`. Both workflows re-run
automatically, so the Docker image and the Pages site both update. Because the server sends
the HTML with `Cache-Control: no-cache`, students always get the latest version on reload.
(Their saved progress is preserved — it lives in their browser, not in the file.)
