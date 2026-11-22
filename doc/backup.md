# Backups (Backrest)

Pleiades doesn't need a full system backup: the OS is the container image
(rebuilt from this repo, `bootc rollback` returns to the previous version) and
apps, dotfiles and dev boxes are recreated by `pleiades-setup`.

What a reinstall **can't** recreate is your data. Back up:

| Path | What |
|---|---|
| `~` (`/var/home/<user>`) | projects, documents, `~/.ssh`, `~/.gnupg`, keyrings (`~/.local/share/keyrings`), Flatpak app data (`~/.var/app`) |
| `/etc` changes | usually few; list them with `sudo ostree admin config-diff` |

Skip caches and things that are rebuilt anyway: `~/.cache`, `node_modules`,
`.venv`, `~/.local/share/containers` (container images).

## Backrest

[Backrest](https://github.com/garethgeorge/backrest) is a web UI and scheduler
for [restic](https://restic.net): encrypted, deduplicated backups to a local
disk, NAS, SFTP, S3 and more.

It runs as a rootless Podman container managed by systemd (Quadlet), so
nothing is added to the image and it updates itself with
`podman-auto-update.timer`.

### Install

```
pleiades-setup backrest
```

This:

- installs `~/.config/containers/systemd/backrest.container`
  (template: `/usr/share/pleiades/backrest.container`)
- starts `backrest.service` and enables it at login
- enables `podman-auto-update.timer` so the container image stays current
- enables lingering (`loginctl enable-linger`) so scheduled backups also run
  while you're logged out

Open <http://localhost:9898> and set a username and password.

### Set up a backup

1. **Add a repository** (where backups go), e.g. a USB disk or a NAS.
   Store the repository password in your password manager: without it the
   backups can't be restored.
2. **Add a plan** (what and when):
   - Paths: `/userdata` (your home folder, mounted read-only)
   - Excludes, for example:
     ```
     /userdata/.cache
     /userdata/.local/share/containers
     /userdata/**/node_modules
     /userdata/**/.venv
     /userdata/restore
     ```
   - Schedule and retention, e.g. daily, keep 7 daily / 4 weekly / 6 monthly.
3. Run the plan once with **Backup now** and check it finishes.

### Restore

In the UI, open a snapshot, pick files and restore them to `/restore`.
They appear in `~/restore` on the host; copy them back from there.

### Back up a local disk

The container only sees your home folder. To back up to a USB disk, add a
mount to `~/.config/containers/systemd/backrest.container`, for example:

```
Volume=/run/media/%u/backup-disk:/repos/usb:Z
```

then `systemctl --user daemon-reload && systemctl --user restart backrest`
and use `/repos/usb` as the repository path.

### Manage

```bash
systemctl --user status backrest      # running?
journalctl --user -u backrest -f      # logs
systemctl --user restart backrest     # after editing the .container file
```
