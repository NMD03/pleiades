# External Monitors

Pleiades handles monitors with two tools:

- **sway** shows windows and workspaces on every connected screen.
- **kanshi** watches for monitors being plugged in or removed and applies a
  saved layout (profile) for the current combination of screens.

`$mod` is the Super/Windows key.

## Shortcuts

### Screens

| Shortcut | Action |
|---|---|
| `$mod+Shift+p` | Mirror the focused screen onto the other screen. Press again to stop |
| `$mod+Ctrl+←/→/↑/↓` | Move focus to the screen in that direction |
| `$mod+Ctrl+Shift+←/→/↑/↓` | Move the current workspace to the screen in that direction |
| `$mod+Shift+m` | Move the focused window to the next screen |

### Windows and workspaces

| Shortcut | Action |
|---|---|
| `$mod+1` … `$mod+0` | Switch to workspace 1–10 |
| `$mod+Shift+1` … `$mod+Shift+0` | Move the focused window to workspace 1–10 |
| `$mod+h/j/k/l` or `$mod+←/↓/↑/→` | Focus the window in that direction |
| `$mod+Shift+h/j/k/l` or `$mod+Shift+arrows` | Move the window in that direction |

A workspace lives on one screen. Switching to a workspace that is on another
screen moves the focus to that screen.

## Extending (default)

When a monitor is plugged in, it **extends** the desktop:

- If a kanshi profile matches the connected screens, its layout (position,
  resolution, scale, screens switched off) is applied.
- Otherwise sway enables the new screen next to the existing ones with its
  preferred resolution.

Use `$mod+Ctrl+Shift+arrows` to move workspaces onto the new screen.

## Mirroring

`$mod+Shift+p` runs `pleiades-mirror`, which shows the focused screen
fullscreen on the other screen using `wl-mirror`. You keep working on your
screen and the other one shows the same content, scaled to fit.

Press `$mod+Shift+p` again (or close the mirror window) to stop. The other
screen then shows its own workspace again.

From a terminal you can pick the screens explicitly:

```bash
pleiades-mirror eDP-1 HDMI-A-1   # mirror eDP-1 onto HDMI-A-1
```

While mirroring, the target screen is covered by the mirror window, so it
can't be used for other windows.

## Saving a layout (kanshi profile)

1. Plug in the monitors and list them:

   ```bash
   swaymsg -t get_outputs
   ```

   Use the full name shown in quotes (e.g. `"Dell Inc. DELL P3425WE BF7SY54"`),
   not the connector (`DP-2`), so the profile works on any port. The laptop
   screen is usually `eDP-1`.

2. Add a profile to `~/.config/kanshi/config` (falls back to
   `/etc/kanshi/config` if you don't have one):

   ```
   profile desk {
       output "Dell Inc. DELL P3425WE BF7SY54" enable mode 3440x1440@59.973Hz position 0,0 scale 1
       output eDP-1 enable mode 1920x1200@60.003Hz position 760,1440 scale 1
   }
   ```

   A profile only applies when **exactly** the listed screens are connected.
   `position` is in logical pixels (after scaling); use `output <name> disable`
   to switch a screen off in that profile.

3. Reload kanshi:

   ```bash
   kanshictl reload
   ```

kanshi only manages layouts. Apps are started from the sway config, and
workspaces can be pinned to screens there:

```
workspace $ws1 output "Dell Inc. DELL P3425WE BF7SY54" eDP-1
```

The first screen in the list that is connected is used.

## Troubleshooting

| Problem | Fix |
|---|---|
| New monitor stays black | `swaymsg -t get_outputs`: is it `active`? Enable it with `swaymsg output <name> enable` |
| Wrong layout applied | Check the names in the kanshi profile match `swaymsg -t get_outputs` exactly, then `kanshictl reload` |
| Layout not applied at all | Run `kanshi` in a terminal to see config errors |
| Mirror shortcut does nothing | Only one screen is connected, or `wl-mirror` isn't installed (`command -v wl-mirror`) |
