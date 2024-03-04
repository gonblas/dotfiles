# Qtile keybindings

from libqtile.config import Key
from libqtile.command import lazy

from .prefs import *

def go_to_group(qtile, index):
    qtile.current_group.use_layout(index)

keys = [Key(key[0], key[1], *key[2:]) for key in [
    # ------------ Window Configs ------------

    # Switch between windows in current stack pane
    ([mod], "j", lazy.layout.down()),
    ([mod], "k", lazy.layout.up()),
    ([mod], "h", lazy.layout.left()),
    ([mod], "l", lazy.layout.right()),

    ([mod, "control"], "h", lazy.screen.prev_group()),
    ([mod, "control"], "l", lazy.screen.next_group()),

    # Change window sizes (MonadTall)
    ([mod, "shift"], "l", lazy.layout.grow()),
    ([mod, "shift"], "h", lazy.layout.shrink()),

    # Toggle floating
    ([mod, "shift"], "f", lazy.window.toggle_floating()),

    # Move windows up or down in current stack
    ([mod, "shift"], "j", lazy.layout.shuffle_down()),
    ([mod, "shift"], "k", lazy.layout.shuffle_up()),

    # Toggle between different layouts as defined below
    ([mod], "Tab", lazy.next_layout()),
    ([mod, "shift"], "Tab", lazy.prev_layout()),
    ([mod, "shift"], "o", lazy.function(go_to_group, 5)),

    # Kill window
    ([mod], "w", lazy.window.kill()),
    ([mod, "shift"], "w", lazy.spawn("tmux kill-server")),

    # Switch focus of monitors
    ([mod], "period", lazy.next_screen()),
    ([mod], "comma", lazy.prev_screen()),

    # Restart Qtile
    ([mod, "control"], "r", lazy.restart()),

    ([mod, "control"], "q", lazy.shutdown()),

    ([mod, "shift"], "l", lazy.spawn("betterlockscreen -l")),

    # Change theme
    ([mod, "control"], "t", lazy.spawn(change_theme)),

    # Reload Xmodmap

    ([mod], "n", lazy.spawn("xmodmap /home/ivan/.Xmodmap")),


    # ------------ App Configs ------------

    # Menu
    ([mod], "m", lazy.spawn(launcher)),

    #Ranger
    ([mod], "r", lazy.spawn("alacritty -e ranger")),

    # Window Nav
    ([mod, "shift"], "m", lazy.spawn("rofi -show window")),

    # Browser
    ([mod], "b", lazy.spawn(browser)),
    ([mod, "shift"], "b", lazy.spawn(private)),

    # File Explorer
    ([mod], "e", lazy.spawn(file_manager)),

    # Terminal
    ([mod], "Return", lazy.spawn(terminal)),

    # Redshift
    ([mod, "shift"], "r", lazy.spawn("redshift -x")),

    # Screenshot
    ([mod, "shift"], "s", lazy.spawn(screenshot)),
    ([],"Print", lazy.spawn(full_screenshot)),

    # Spotify
    ([mod], "p", lazy.spawn(spotify)),

    # Zathura

    ([mod], "z", lazy.spawn(pdf_viewer)),

    # Obsidian

    ([mod], "o", lazy.spawn(obsidian)),

    # Discord

    ([mod], "d", lazy.spawn(discord)),

    # Visual Studio Code

    ([mod], "c", lazy.spawn(vscode)),

    # ------------ Hardware Configs ------------

    # Volume
    ([], "XF86AudioLowerVolume", lazy.spawn(
        "pamixer --decrease 5"
    )),
    ([], "XF86AudioRaiseVolume", lazy.spawn(
        "pamixer --increase 5"
    )),
    ([], "XF86AudioMute", lazy.spawn(
        "pamixer --toggle-mute"
    )),

    # Brightness
    ([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%")),
    ([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-")),
]]
