import os
import subprocess
from typing import List  # noqa: F401
import psutil

from libqtile.config import (
    Key,
    Screen,
    Group,
    Drag,
    Click,
    ScratchPad,
    DropDown,
    Match,
)
from libqtile import layout, bar, widget, hook
from libqtile.lazy import lazy
from libqtile import qtile
from qtile_extras import widget
from qtile_extras.widget.decorations import BorderDecoration
from qtile_extras.widget.decorations import RectDecoration

from .pallete import colors

laptop=1

widget_defaults = dict(
    font="FiraCode Nerd Font",
    fontsize=12,
    padding=4,
    background=colors[0],
    decorations=[
        BorderDecoration(
            colour=colors[0],
            border_width=[2, 0, 2, 0],
        )
    ],
)
extension_defaults = widget_defaults.copy()

group_box_settings = {
    "padding": 5,
    "borderwidth": 4,
    "active": colors[8],
    "inactive": colors[10],
    "disable_drag": True,
    "rounded": True,
    "highlight_color": colors[2],
    "block_highlight_text_color": colors[12],
    "highlight_method": "block",
    "this_current_screen_border": colors[14],
    "this_screen_border": colors[7],
    "other_current_screen_border": colors[14],
    "other_screen_border": colors[14],
    "foreground": colors[1],
    "background": colors[14],
    "urgent_border": colors[3],
}


# Mouse_callback functions
def open_launcher():
    qtile.cmd_spawn("rofi -show drun")


def kill_window():
    qtile.cmd_spawn("xdotool getwindowfocus windowkill")


def open_pavu():
    qtile.cmd_spawn("pavucontrol")


def open_powermenu():
    qtile.cmd_spawn(os.path.expanduser("~/.local/bin/powermenu.sh"))


primary_widgets = [
        widget.TextBox(
            text="󰉔",
            foreground=colors[13],
            background=colors[0],
            font="Font Awesome 6 Free Solid",
            fontsize=18,
            padding=20,
            mouse_callbacks={"Button1": open_launcher},
        ),
        widget.TextBox(
            text="",
            foreground=colors[14],
            background=colors[0],
            fontsize=18,
            padding=0,
        ),
        widget.GroupBox(
            font="UbuntuMono Nerd Font",
            fontsize=18,
            **group_box_settings,
        ),
        widget.TextBox(
            text="",
            foreground=colors[14],
            background=colors[0],
            fontsize=18,
            padding=0,
        ),
        widget.Sep(
            linewidth=0,
            foreground=colors[2],
            background=colors[0],
            padding=10,
            size_percent=40,
        ),
        widget.TextBox(
            text="",
            foreground=colors[14],
            background=colors[0],
            fontsize=18,
            padding=0,
        ),
        widget.CurrentLayoutIcon(
            custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
            foreground=colors[2],
            background=colors[14],
            padding=0,
            scale=0.55,
        ),
        widget.WindowCount(
            background=colors[14],
        ),
        widget.TextBox(
            text="",
            foreground=colors[14],
            background=colors[0],
            fontsize=18,
            padding=0,
        ),
        widget.Sep(
            linewidth=0,
            foreground=colors[2],
            padding=10,
            size_percent=50,
        ),
        widget.Spacer(),
        widget.TextBox(
            text=" ",
            foreground=colors[1],
            background=colors[0],
            # fontsize=38,
            font="Font Awesome 6 Free Solid",
        ),
        widget.WindowName(
            background=colors[0],
            foreground=colors[1],
            width=bar.CALCULATED,
            empty_group_string="Desktop",
            max_chars=92,
            mouse_callbacks={"Button2": kill_window},
        ),
        widget.Spacer(),
        widget.Systray(
            icon_size=20,
            background=colors[0],
            padding=6,
        ),
        widget.Sep(
            linewidth=0,
            foreground=colors[2],
            padding=10,
            size_percent=50,
        ),
        widget.TextBox(
            text="",
            foreground=colors[14],
            background=colors[0],
            fontsize=18,
            padding=0,
        ),
        widget.TextBox(
            text=" ",
            foreground=colors[8],
            background=colors[14],
            font="Font Awesome 6 Free Solid",
            # fontsize=38,
        ),
        widget.PulseVolume(
            foreground=colors[8],
            background=colors[14],
            limit_max_volume="True",
            mouse_callbacks={"Button3": open_pavu},
        ),
        widget.TextBox(
            text="",
            foreground=colors[14],
            background=colors[0],
            fontsize=18,
            padding=0,
        ),
        widget.Sep(
            linewidth=0,
            foreground=colors[2],
            padding=10,
            size_percent=50,
        ),
        widget.TextBox(
            text="",
            foreground=colors[14],
            background=colors[0],
            fontsize=18,
            padding=0,
        ),
        widget.TextBox(
            text="󰊗 ",
            font="Font Awesome 6 Free Solid",
            foreground=colors[7],  # fontsize=38
            background=colors[14],
        ),
        widget.Memory(
            measure_mem="M",
            foreground=colors[7],
            background=colors[14],
            padding=5,
        ),
        widget.TextBox(
            text="",
            foreground=colors[14],
            background=colors[0],
            fontsize=18,
            padding=0,
        ),
        widget.Sep(
            linewidth=0,
            foreground=colors[2],
            padding=10,
            size_percent=50,
        ),
        widget.TextBox(
            text="",
            foreground=colors[14],
            background=colors[0],
            fontsize=18,
            padding=0,
        ),
        widget.TextBox(
            text=" ",
            font="Font Awesome 6 Free Solid",
            foreground=colors[6],  # fontsize=38
            background=colors[14],
        ),
        widget.Clock(
            format="%a, %b %d",
            background=colors[14],
            foreground=colors[6],
        ),
        widget.TextBox(
            text="",
            foreground=colors[14],
            background=colors[0],
            fontsize=18,
            padding=0,
        ),
        widget.Sep(
            linewidth=0,
            foreground=colors[2],
            padding=10,
            size_percent=50,
        ),
        widget.TextBox(
            text="",
            foreground=colors[14],
            background=colors[0],
            fontsize=18,
            padding=0,
        ),
        widget.TextBox(
            text=" ",
            font="Font Awesome 6 Free Solid",
            foreground=colors[4],  # fontsize=38
            background=colors[14],
        ),
        widget.Clock(
            format="%I:%M %p",
            foreground=colors[4],
            background=colors[14],
        ),
        widget.TextBox(
            text="",
            foreground=colors[14],
            background=colors[0],
            fontsize=18,
            padding=0,
        ),
        widget.TextBox(
            text="⏻",
            foreground=colors[13],
            font="Font Awesome 6 Free Solid",
            fontsize=14,
            padding=20,
            mouse_callbacks={"Button1": open_powermenu},
        ),
]

conditional_widgets = [
    widget.BatteryIcon(
        theme_path='~/.config/qtile/assets/battery/',
        foreground=colors[8],
        background=colors[14],
        scale=0.9,
    ),
    widget.Battery(
        foreground=colors[8],
        background=colors[14],
        format='{percent:2.0%}',
        fontsize=13,
    ),
]

position_to_insert = 19
if laptop==1:
    primary_widgets[position_to_insert:position_to_insert] = conditional_widgets
