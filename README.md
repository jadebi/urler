# urler
urler | URL shortener but it preserves the headers so the embeds look the same.

Build with: `docker build .`

Local testing: `docker run --rm --name alpine-temp -it alpine:3.21 sh -c "apk add lua5.4 lua5.4-dev luarocks musl-dev openssl-dev sqlite-dev gcc make bsd-compat-headers && sh"`

Roadmap
- Self signed Certificates
- Cloudflare Turnstile
- User System
  - Registration
  - URL management
  - Admin Dashboard
- URL limit per client

database scheme: `https://www.drawdb.app/`, manually import the `database.dbml` file into the website
