# urler
urler | URL shortener but it preserves the headers so the embeds look the same.

Build with: `docker build .`

Local testing: `docker run --rm --name alpine-temp -it alpine:3.21 sh -c "apk add lua5.4 lua5.4-dev luarocks musl-dev openssl-dev sqlite-dev gcc make bsd-compat-headers && sh"`

Roadmap
- Self signed Certificates
- Cloudflare Turnstile
- Counting of URLs per IP
- URL limit per client


database scheme: https://www.drawdb.app/editor/diagrams/1a423da1-d069-454e-a4a6-f724c03e44cc
