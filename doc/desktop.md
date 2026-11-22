# Desktop Environment

Sway is used as desktop environment using the following additional software:

- kanshi (display arrangement)
- kickoff (app launcher)
- alacritty (default terminal)
- dunst (notification service)
- gtklock (lock screen, tuigreet look: `/etc/xdg/gtklock/style.css`; `$mod+Ctrl+l`, auto-lock after 5 min and before suspend)
- greetd + tuigreet (login manager)
- firefox (default browser)
- grim (screenshots)
- brightnessctl (adjusting brigthness)
- mate-polkit (password dialog for admin actions, started from `/etc/sway/config.d/50-polkit-agent.conf`)
- tuned-ppd (power profiles: `powerprofilesctl list`, `powerprofilesctl set power-saver|balanced|performance`)

## Start GUI session

`greetd` starts the graphical session after boot -> `systemctl enable greetd.service`

## Config

After initial boot a minimal working sway config is used. Later this config can be overwritten using the dotfiles-repo or any other custom config file.

## Monitors

See [monitors.md](./monitors.md) for external monitors, mirroring and the most important shortcuts.
