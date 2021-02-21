# -*- coding: utf-8 -*-
import os
import subprocess
from typing import List  # noqa: F401

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Screen, Match
from libqtile.lazy import lazy

mod = "mod4"
terminal = "alacritty"

color_background = '#282a36'
color_current = '#44475a'
color_foreground = '#f8f8f2'
color_comment = '#6272a4'
color_cyan = '#8be9fd'
color_green = '#50fa7b'
color_orange = '#ffb86c'
color_pink = '#ff79c6'
color_purple = '#bd93f9'
color_red = '#ff5555'
color_yellow = '#f1fa8c'

keys = [
    # Switch between windows in current stack pane
    Key([mod], "k", lazy.layout.down(),
        desc="Move focus down in stack pane"),
    Key([mod], "j", lazy.layout.up(),
        desc="Move focus up in stack pane"),

    # Move windows up or down in current stack
    Key([mod, "shift"], "k", lazy.layout.shuffle_down(),
        desc="Move window down in current stack "),
    Key([mod, "shift"], "j", lazy.layout.shuffle_up(),
        desc="Move window up in current stack "),

    Key([mod], "space", lazy.spawn("rofi -show run"), desc="Open Rofi"),

    Key([], "Print", lazy.spawn("escrotum -Cs"), desc="Take quick screenshot"),
    Key(["shift"], "Print",
        lazy.spawn('escrotum -s "~/Images/Screenshots/%Y-%m-%d-%H%M%S.png"'),
        desc="Take and save screenshot"
    ),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),

    Key([mod, "control"], "r", lazy.restart(), desc="Restart qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown qtile"),
    Key([mod], "r", lazy.spawncmd(),
        desc="Spawn a command using a prompt widget"),
    
    Key([mod], "equal",
        lazy.layout.grow(),
        lazy.layout.increase_nmaster(),
        desc='Expand window (MonadTall), increase number in master pane (Tile)'
    ),
    Key([mod], "minus",
        lazy.layout.shrink(),
        lazy.layout.decrease_nmaster(),
        desc='Shrink window (MonadTall), decrease number in master pane (Tile)'
    ),
]

groups = [
    Group('1', layout='monadtall'),
    Group('2', layout='monadtall'),
    Group('3', layout='monadtall'),
    Group('4', layout='monadtall'),
    Group('5', layout='monadtall'),
    Group(
        'ﭮ Discord',
        layout='max',
        matches=[Match(wm_class=["discord"])],
        exclusive=True
    ),
    Group(
        ' Telegram',
        layout='max',
        matches=[Match(wm_class=["TelegramDesktop"])],
        exclusive=True
    ),
    Group(' Others', layout='max'),
]

for i in groups[:5]:
    keys.extend([
        # mod1 + number of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        # mod1 + shift + number of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),
    ])

layouts = [
    layout.MonadTall(
        margin=20,
        border_focus=color_comment,
        border_normal=color_background
    ),
    layout.Max(),
    layout.Floating(),
    #layout.Stack(num_stacks=2),
    # Try more layouts by unleashing below layouts.
    # layout.Bsp(),
    # layout.Columns(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='Hack Nerd Font',
    fontsize=12,
    padding=3,
    foreground = color_foreground,
    background = color_background
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Sep(
                    linewidth = 0,
                    padding = 6,
                ),
                widget.TextBox(
                    text = "λ",
                    mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn('rofi -show run')}
                ),
                widget.Sep(
                    linewidth = 0,
                    padding = 6,
                ),
                widget.GroupBox(
                    fontsize = 10,
                    margin_y = 3,
                    margin_x = 0,
                    padding_y = 5,
                    padding_x = 3,
                    borderwidth = 3,
                    active = color_foreground,
                    inactive = color_foreground,
                    rounded = False,
                    disable_drag = True,
                    highlight_color = color_current,
                    highlight_method = "line",
                    this_current_screen_border = color_comment,
                    other_current_screen_border = color_background,
                    other_screen_border = color_background,
                ),
                widget.Sep(
                    linewidth = 0,
                    padding = 10,
                ),
                widget.WindowName(
                    foreground = color_comment,
                    padding = 0
                ),
                widget.CurrentLayout(
                    foreground = color_orange,
                    padding = 5
                ),
                widget.Sep(
                    linewidth = 0,
                    padding = 5,
                ),
                widget.TextBox(
                    text = " ",
                    padding = 2,
                    background = color_red,
                    fontsize = 11,
                ),
                widget.ThermalSensor(
                    threshold = 90,
                    padding = 5,
                    foreground_alert = color_background,
                    background = color_red
                ),
                widget.Sep(
                    linewidth = 0,
                    padding = 5,
                    background = color_red,
                ),
                widget.TextBox(
                    text = " ⟳",
                    padding = 2,
                    background = color_purple,
                    fontsize = 14
                ),
                widget.TextBox(
                    text = "Updates ",
                    padding = 5,
                    mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn(terminal + ' -e update-all')},
                    background = color_purple
                ),
                widget.Net(
                    interface = "enp34s0",
                    format = ' {down} ↓↑ {up} ',
                    background = color_current,
                    padding = 5
                ),
                widget.Clock(
                    format = " %A, %B %d  [ %H:%M ]"
                ),
                widget.Sep(
                    linewidth = 0,
                    padding = 10,
                ),
                widget.Systray(
                    padding = 5
                ),
            ],
            24,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None  # WARNING: this is deprecated and will be removed soon
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

@hook.subscribe.startup_once
def start_once():
    autostart = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([autostart])


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
