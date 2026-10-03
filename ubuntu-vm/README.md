# Method 2 — Jellyfin on an Ubuntu VM (native)

Install Jellyfin directly into a fresh **Ubuntu 22.04 or 24.04** system. The official installer
adds Jellyfin's package repository and installs the `jellyfin` package, which ships a
`jellyfin.service` systemd unit that is enabled on boot — the "traditional" way of running a
service on Linux.

## 1. Install

Option A — run the bundled script (recommended):

```bash
sudo bash ubuntu-vm/setup.sh
```

Option B — run the official installer by hand (same steps, checksum verified):

```bash
cd ~
curl -fsSL https://repo.jellyfin.org/install-debuntu.sh -O install-debuntu.sh
curl -fsSL https://repo.jellyfin.org/install-debuntu.sh.sha256sum -O install-debuntu.sh.sha256sum
sha256sum -c install-debuntu.sh.sha256sum      # expect: install-debuntu.sh: OK
sudo bash install-debuntu.sh
```

(`less install-debuntu.sh` shows what the installer does before you run it.)

## 2. Confirm it's running

The package enables and starts the service automatically. Verify:

```bash
systemctl is-enabled jellyfin.service   # enabled
systemctl status jellyfin.service       # active (running)
journalctl -u jellyfin -f               # watch logs, Ctrl-C to stop
```

## 3. Grant media access

The `jellyfin` system user needs read access to your media folder. Point `MEDIA_DIR` at a folder
the `jellyfin` user can read — the simplest approach is to add it to a shared group and grant that
group read access, e.g.:

```bash
sudo usermod -aG medialog jellyfin
sudo setfacl -R -m g:medialog:rx /media        # or chmod/chown as appropriate
```

Then add the folder as a library in the wizard.

## 4. Access

Open `http://<vm-ip>:8096` and run the setup wizard (create an admin user, pick a language).

## Optional — set the timezone for the service

The packaged unit inherits the host timezone. To pin it explicitly, drop in the provided
`tz.conf`. This is the "traditional" systemd customization path: a **drop-in** that augments the
packaged unit rather than replacing it.

```bash
sudo mkdir -p /etc/systemd/system/jellyfin.service.d
sudo cp ubuntu-vm/tz.conf /etc/systemd/system/jellyfin.service.d/tz.conf
sudo systemctl daemon-reload
sudo systemctl restart jellyfin
```

## Update

```bash
sudo apt update && sudo apt upgrade jellyfin
```

The service restarts automatically if it is running.

## Back up

Configuration lives in `/etc/jellyfin` (config) and `/var/lib/jellyfin` (library database and
cache). Back those up to preserve your libraries and settings.
