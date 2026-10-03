# Method 1 — Jellyfin via Docker Compose

Containerized Jellyfin using the official `jellyfin/jellyfin` image. A working stack comes from
three files:

- `docker-compose.yml` — the stack definition (editable).
- `.env.example` — copy to `.env` and edit the values (paths, timezone, user IDs).

> **Run it on Linux.** Container-on-macOS/Windows is unsupported (no hardware transcoding, broken
> scanning). This assumes a Linux host with Docker Compose v2 — the `docker compose` plugin, not
> the legacy `docker-compose` command.

## 1. Configure

```bash
cd docker-compose
cp .env.example .env
```

Edit `.env`:

- `TZ` — your IANA timezone (e.g. `America/New_York`).
- `PUID` / `PGID` — your host user and group (`id -u` / `id -g`). This makes mounted media
  readable and writable by the container.
- `MEDIA_DIR` — the folder on the host that holds your media.
- Paths for `JELLYFIN_CONFIG` / `JELLYFIN_CACHE` — where settings and cache live.

Every field has a default, so you can skip `.env` entirely and just run `docker compose up -d`.

## 2. Start

```bash
docker compose up -d
```

## 3. Access

Open `http://<host-ip>:8096` and run the setup wizard (create an admin user, pick a language).

## What's mapped

| Host | Container | Purpose |
|---|---|---|
| `${JELLYFIN_CONFIG}` | `/config` | Settings and the library database |
| `${JELLYFIN_CACHE}` | `/cache` | Transient cache (safe to clear) |
| `${MEDIA_DIR}` | `/media` | Your media, mounted read-only |

| Port | Protocol | Purpose |
|---|---|---|
| 8096 | TCP | Web UI and API |
| 7359 | UDP | SSDP auto-discovery on the local network |

## Add more media

Repeat a mount line in the `volumes:` block of `docker-compose.yml`, then add a matching library
in the wizard:

```yaml
      - /path/to/movies:/movies:ro
      - /path/to/tv:/tv:ro
```

## Update

```bash
docker compose pull
docker compose up -d
```

Changing the `JELLYFIN_VERSION` in `.env` to a specific tag (e.g. `10.11.0`) makes updates
pinned and reproducible.

## Back up

Your entire setup lives in `JELLYFIN_CONFIG`. Back that folder up to preserve libraries, users,
and settings.
