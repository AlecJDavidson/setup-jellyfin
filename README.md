# Setup Jellyfin

Minimal, copy-paste guides for running [Jellyfin](https://jellyfin.org) — the free, open-source
media server — on your own hardware. Two methods, same outcome: a server that organizes your
media and streams it to any client.

- [Method 1: Docker Compose](docker-compose/) — containerized, easy to update and remove.
- [Method 2: Ubuntu VM (native)](ubuntu-vm/) — installed into the OS, full hardware transcoding.

## Pick a method

| | Docker Compose | Ubuntu VM (native) |
|---|---|---|
| Install target | A container | The OS (via a systemd service) |
| Update method | `docker compose pull` then `up` | `sudo apt upgrade jellyfin` |
| Hardware transcoding | Works on Linux hosts only | Full support out of the box |
| Isolation | Contained; easy to remove | System-wide package |
| Best for | Reproducibility, NAS, existing Docker | Dedicated VM/server, HW transcode |

**Rule of thumb:** If you already run Docker or want something you can recreate from one file, use
Compose. If you want maximum transcoding performance on a dedicated box, install natively.

> **Host note:** Jellyfin officially supports containers only on **Linux**. Running the container
> on macOS or Windows leaves hardware transcoding and library scanning broken, and is unsupported.
> Run the Compose stack on a Linux host (a VM, NUC, or your Ubuntu server). The native guide
> targets Linux/Ubuntu.

## What's shared by both methods

Whichever method you choose, the first-time experience is the same:

1. Open `http://<server-ip>:8096` in a browser (default port **8096**).
2. Run the setup wizard: create the admin user, pick a language.
3. Add **libraries** — point Jellyfin at a folder of media and choose the content type (movies/TV).
4. Install a client (phone, browser, Android TV, etc.) and sign in with your admin account.

Jellyfin transcodes on the fly when a client can't play a file directly (different codec,
bandwidth, or device). No extra setup is needed for basic streaming.

## Where to go next

- [Docker Compose guide](docker-compose/) → runnable `docker-compose.yml` + walkthrough.
- [Ubuntu VM guide](ubuntu-vm/) → one-script native install + systemd.

## Sources

These guides follow the official documentation:

- [Installation — Container](https://jellyfin.org/docs/general/installation/container)
- [Installation — Linux](https://jellyfin.org/docs/general/installation/linux)
