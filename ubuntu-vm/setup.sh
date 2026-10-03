#!/usr/bin/env bash
# One-shot Jellyfin install for Ubuntu/Debian, using the official checksummed installer script.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/<repo>/main/ubuntu-vm/setup.sh | sudo bash
# or clone this repo and run:  sudo bash ubuntu-vm/setup.sh
#
# The script downloads the official installer, verifies its checksum, installs Jellyfin, then
# ensures the packaged systemd service is enabled and running.
set -euo pipefail

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "Run this with sudo." >&2
  exit 1
fi

WORKDIR="$(mktemp -d)"
cd "$WORKDIR"

echo ">> Downloading the official Jellyfin Ubuntu installer and verifying its checksum..."
curl -fsSL https://repo.jellyfin.org/install-debuntu.sh -O install-debuntu.sh
curl -fsSL https://repo.jellyfin.org/install-debuntu.sh.sha256sum -O install-debuntu.sh.sha256sum

if ! sha256sum -c install-debuntu.sh.sha256sum; then
  echo ">> Checksum verification FAILED. Aborting." >&2
  exit 1
fi

echo ">> Installing Jellyfin (this may take a few minutes)..."
sudo bash install-debuntu.sh

echo ">> Enabling and starting the jellyfin.service..."
sudo systemctl enable --now jellyfin

export SYSTEMD_PAGER=
echo ">> Status:"
systemctl status jellyfin.service

echo
echo ">> Done. Open http://<this-host-ip>:8096 in a browser and run the setup wizard."
