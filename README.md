

<p align="center">
  <img src="src/www/icons/logo.svg" alt="urler logo" width="128"> urler
</p>

A URL shortener that keeps the original HTTP headers so your embeds don't look busted when someone shares a link.

Built on [OpenResty](https://openresty.org/) (nginx + LuaJIT) with SQLite storage.

## How it works

When you feed urler a URL, it stores the original page's meta tags alongside the redirect. So when Discord, Twitter, Telegram, or whatever scrapes the short link for a preview card, it sees the same Open Graph tags, same title, same description as the original destination. No blank embed cards, no wrong previews.

## Quick start

```bash
docker compose up --build
```

_Public pre-built image coming soon..._

That's it. Open `http://localhost:8080` and paste a URL.

### Environment variables

| Variable | Default | Description |
|---|---|---|
| `BASE_URL` | `http://localhost` | Public-facing URL of your instance |
| `PORT` | `8080` | Port to listen on (inside the container) |
| `DATA_FOLDER` | `/urler/data` | Where the SQLite database lives |
| `LOG_FORMAT` | `text` | `text` or `json` |
| `DEBUG` | `false` | `true` / `false` - enables debug log output |

### Custom docker-compose

```yaml
services:
  urler:
    container_name: urler
    build: .
    ports:
      - '8080:8080'
    volumes:
      - ./data:/urler/data
    environment:
      BASE_URL: "http://localhost"
      PORT: "8080"
      DATA_FOLDER: "/urler/data"
      LOG_FORMAT: "json"
      DEBUG: "true"
```

## API

### `POST /api/shorten`

```json
// Request
{ "url": "https://example.com/some/long/path" }

// Response
{ "duration": 0.000432, "code": "aB3xK9mQ" }
```

The `code` is a random 8-character alphanumeric string. The `duration` is how long it took to generate (in seconds, monotonic clock). The actual redirect and embed handling is still being wired up - right now the API generates the code and that's where it ends. More coming.

### Rate limiting

10 requests per second per IP. Hit the limit and you get a `429` with `{"error":"too many requests"}`.

## Development

### Building

```bash
docker build .
```

Or with `docker compose`:

```bash
docker compose up --build
```

Then inside, you can run the Lua parts directly with `lua5.4` (though OpenResty-specific stuff like `ngx.*` and `resty.random` won't work outside of nginx).

### Code style

Lua is formatted with [StyLua](https://github.com/JohnnyMorganz/StyLua) using the config in `.stylua.toml` - 2-space indents, double quotes, 120 column width. The VS Code workspace settings in `.luarc.json` configure the Lua language server for LuaJIT + OpenResty APIs.

### Database schema

The schema is defined in `database.dbml`. You can visualize it at [drawdb.app](https://www.drawdb.app/) by importing that file.

```dbml
Table urls {
  id       integer       [pk, increment, not null, unique]
  date     datetime      [not null]
  ip       text(65535)   [not null]
  short    text(65535)   [pk, not null, unique]
  url      text(65535)   [not null, unique]
  metaUrl  text(65535)   [not null]
  metaHtml text(65535)   [not null]
  metaFetch datetime
}
```

## Roadmap

- [x] Basic URL shortening API
- [ ] Trusted proxies (`set_real_ip_from`)
- [ ] Configurable log level
- [ ] Self-signed certificates (HTTPS out of the box)
- [ ] Cloudflare Turnstile
- [ ] User system
  - [ ] Registration
  - [ ] URL management
  - [ ] Admin dashboard
- [ ] Per-client URL limits
- [ ] Actual redirect + embed proxy (generate a page with the original meta tags)

## License

AGPL-3.0-only. See [LICENSE](LICENSE).
