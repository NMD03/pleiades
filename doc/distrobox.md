# Distrobox

Pleiades keeps the host image small. Development tools and project
dependencies live in [distrobox](https://distrobox.it) containers: they share
your home folder, network and display with the host, but have their own
package manager (`dnf`, `apt`) and can be thrown away at any time.

## Default boxes

`pleiades-setup` (step `distrobox`) creates these from
`~/.config/distrobox/assemble.ini` (in the dotfiles repo):

| Box | Based on | Purpose |
|---|---|---|
| `fedora-dev` | `fedora:latest` + zsh, neovim, git, tmux, ripgrep, fd, eza | template for Fedora project boxes, saved as image `localhost/fedora` |
| `ubuntu-dev` | `ubuntu:24.04` + the same tools | template for Ubuntu project boxes, saved as image `localhost/ubuntu` |
| `tools` | `fedora:latest` | extra CLI/GUI tools for the host, see [below](#tools-box-install-and-export-tools) |

```bash
distrobox list              # all boxes and their state
distrobox enter fedora-dev  # open a shell inside a box (exit with `exit`)
```

## New project boxes

Use one box per project, so dependencies of different projects don't mix.
Start from one of the templates so your shell and tools are already there.

**From the saved template image** (recommended):

```bash
distrobox create --name vulniverse --image localhost/fedora
distrobox enter vulniverse
sudo dnf install -y nodejs npm uv      # project-specific packages
```

Use `localhost/ubuntu` for an Ubuntu box.

**By cloning the template box directly** (picks up anything you installed in
`fedora-dev` since the image was saved; the template must be stopped):

```bash
distrobox stop fedora-dev
distrobox create --name vulniverse --clone fedora-dev
```

**Reproducible**: add the box to `assemble.ini` in your dotfiles and run
`distrobox assemble create --file ~/.config/distrobox/assemble.ini`:

```ini
[vulniverse]
image=localhost/fedora
additional_packages="nodejs npm uv"
```

Options worth knowing for `distrobox create`:

| Option | Effect |
|---|---|
| `--home ~/boxes/<name>` | separate home folder, keeps the box's dotfiles and caches out of your real home |
| `--additional-packages "a b"` | install packages while creating the box |
| `--init` | run systemd inside the box (for services like databases) |

Remove a box (your files in `~` are not touched):

```bash
distrobox rm vulniverse
```

### Refresh the templates

The template images are snapshots. Rebuild them now and then so new boxes
start with current packages:

```bash
distrobox rm -f fedora-dev ubuntu-dev
podman rmi localhost/fedora localhost/ubuntu
pleiades-setup distrobox
```

Existing project boxes are not affected; update them inside with
`sudo dnf upgrade` / `sudo apt upgrade`.

## Tools box: install and export tools

The `tools` box is for programs you want to use **on the host** without
adding them to the Pleiades image.

1. Install the tool inside the box:

   ```bash
   distrobox enter tools
   sudo dnf install -y httpie
   ```

2. Export it to the host (still inside the box):

   ```bash
   # command-line tool -> wrapper script in ~/.local/bin on the host
   distrobox-export --bin /usr/bin/http --export-path ~/.local/bin

   # GUI app -> desktop entry and icon on the host
   distrobox-export --app gimp
   ```

3. Use it on the host like any other command (`http`, `gimp`). It runs inside
   the `tools` box, which starts automatically when needed.

List and remove exports (inside the box):

```bash
distrobox-export --list-binaries -ep ~/.local/bin
distrobox-export --list-apps
distrobox-export --bin /usr/bin/http --export-path ~/.local/bin --delete
distrobox-export --app gimp --delete
```

Without exporting you can always run a single command:

```bash
distrobox enter tools -- http example.org
```

### Keep the tools reproducible

Tools installed by hand are lost when the box is recreated. Put them in
`assemble.ini` instead and `distrobox assemble create` installs and exports
them:

```ini
[tools]
image=registry.fedoraproject.org/fedora:latest
additional_packages="httpie"
exported_bins="/usr/bin/http"
exported_bins_path="~/.local/bin"
```

Recreate the box after changing it:

```bash
distrobox assemble create --replace --file ~/.config/distrobox/assemble.ini --name tools
```

## When to use what

| Need | Use |
|---|---|
| GUI desktop app | Flatpak (`install_pleiades_flatpak`, `flatpak install`) |
| Dev dependencies of one project | a project box |
| CLI tool you use everywhere | `tools` box + `distrobox-export --bin` |
| System component (drivers, services, desktop) | the Pleiades image (`build_files/`) |
