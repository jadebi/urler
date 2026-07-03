# urler
urler | URL shortener but it preserves the headers so the embeds look the same.

Build with: `docker build .`

Local testing: `docker run --rm --name alpine-temp -it alpine:3.21 sh -c "apk add lua5.4 lua5.4-dev luarocks musl-dev openssl-dev sqlite-dev gcc make bsd-compat-headers && sh"`

Roadmap
- Cloudflare Turnstile
- Counting of URLs per IP
- URL limit per client