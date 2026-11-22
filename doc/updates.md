# Updates, rollback and switching images (bootc)

Pleiades is installed from a container image and updated as a whole: an
update downloads the new image, prepares it as a new **deployment** next to the
running one and switches to it on the next boot. The previous deployment is
kept, so you can always go back.

Nothing is installed with `dnf` on the host; changes to the system go into the
image (this repo) and arrive with the next update.

## Image tags

CI publishes to `ghcr.io/nmd03/pleiades`:

| Tag | Built from | Updated |
|---|---|---|
| `latest` | `main` | on every push to `main` and daily |
| `YYYYMMDD`, `latest.YYYYMMDD` | `main` | fixed snapshot of that day |
| `dev` | `dev` | on every push to `dev` |
| `dev.YYYYMMDD` | `dev` | fixed snapshot of that day |

Use `latest` for daily use, `dev` to test changes before merging, and a dated
tag to pin a known good version.

Available tags: <https://github.com/NMD03/pleiades/pkgs/container/pleiades>,
or `skopeo list-tags docker://ghcr.io/nmd03/pleiades`.

## Status

```bash
sudo bootc status
```

Shows up to three deployments:

| Entry | Meaning |
|---|---|
| `booted` | what is running now |
| `staged` | downloaded update, becomes active on the next boot |
| `rollback` | the previous deployment, used by `bootc rollback` |

Each entry shows the image (`ghcr.io/nmd03/pleiades:<tag>`), its version
(e.g. `dev.20261122`) and digest.

## Upgrade

```bash
sudo bootc upgrade --check    # is there a newer image for the current tag?
sudo bootc upgrade            # download and stage it, active after reboot
sudo reboot

sudo bootc upgrade --apply    # download, stage and reboot immediately
```

### Automatic updates

`rpm-ostreed-automatic.timer` is enabled with `AutomaticUpdatePolicy=stage`
(`/etc/rpm-ostreed.conf`): updates are downloaded and staged in the
background, and become active the next time **you** reboot. Nothing reboots on
its own. `sudo bootc status` shows a `staged` entry when one is waiting.

Flatpak apps are updated separately by `flatpak-system-update.timer`, or by
hand with `flatpak update`.

## Rollback

If an update breaks something, go back to the previous deployment:

```bash
sudo bootc rollback           # previous deployment on next boot
sudo reboot

sudo bootc rollback --apply   # same, reboot immediately
```

The deployments swap places: the broken one becomes the `rollback` entry, so
running `bootc rollback` again returns to it. A rollback also discards a
`staged` update.

At boot you can also pick the previous deployment in the boot menu without
running any command.

To stay on the old version until a fix is published, pin it with a dated tag
(see below) instead of rolling back, otherwise the next automatic update
stages the broken image again.

## Switch to another tag or image

```bash
sudo bootc switch ghcr.io/nmd03/pleiades:dev            # follow dev
sudo bootc switch ghcr.io/nmd03/pleiades:latest         # back to main
sudo bootc switch ghcr.io/nmd03/pleiades:dev.20261122   # pin a snapshot
sudo reboot
```

`switch` downloads the image, stages it and from then on `bootc upgrade`
follows the new tag. Add `--apply` to reboot immediately.

For another tag of the same image there is a shortcut:

```bash
sudo bootc upgrade --tag dev
```

A dated tag never changes, so a pinned system gets no updates until you switch
back to `latest` or `dev`.

### Test a local build

Images built with `just build` live in local Podman storage. Boot one without
pushing it (it needs to be in root's storage):

```bash
just build localhost/pleiades dev
sudo podman image scp $USER@localhost::localhost/pleiades:dev root@localhost::
sudo bootc switch --transport containers-storage localhost/pleiades:dev
sudo reboot
```

Switch back to the registry afterwards
(`sudo bootc switch ghcr.io/nmd03/pleiades:dev`), otherwise there are no updates.

## What survives updates

| Path | On update / rollback |
|---|---|
| `/usr` | replaced by the new image (read-only) |
| `/etc` | 3-way merge: your local changes are kept, unchanged files get the new image's version. A rollback also restores the older `/etc` |
| `/var`, `/var/home` (`~`) | never touched: your files, Flatpaks, containers, Incus |

List your local `/etc` changes with `sudo ostree admin config-diff`.

## Troubleshooting

| Problem | Fix |
|---|---|
| `bootc upgrade` says no update, but CI built one | check the tag you follow (`bootc status`) and that the CI run for that branch finished |
| Changes from the repo are missing after an update | they're only in the image after a push to the followed branch (`dev` or `main`) and a finished CI build |
| A file in `/etc` keeps your old version | you changed it locally, so the update keeps yours; compare with `/usr/etc/<file>` and delete or merge it |
