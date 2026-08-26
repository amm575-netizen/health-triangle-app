# Health Triangle SMART Goal App — static site served by nginx.
# The app is a single self-contained HTML file; it has no backend and
# stores nothing on the server. Students' data stays in their own browser.

FROM nginx:1.27-alpine

# Serve the app as the site root (index.html loads at "/").
COPY index.html /usr/share/nginx/html/index.html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# nginx listens on 80 inside the container.
EXPOSE 80

# Simple healthcheck so orchestrators know the site is up.
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1/ || exit 1
