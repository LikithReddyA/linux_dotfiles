import os
import subprocess
from libqtile import layout, hook, qtile, bar, widget
from libqtile.config import EzKey as Key, Group, Screen, Match
from libqtile.lazy import lazy
import colors
from widgets.volume import EventVolume

myTerm = "kitty"      # My terminal of choice
myBrowser = "qutebrowser"       # My browser of choice

# A function for hide/show all the windows in a group
@lazy.function
def minimize_all(qtile):
    for win in qtile.current_group.windows:
        if hasattr(win, "toggle_minimize"):
            win.toggle_minimize()

# A function for toggling between MAX and MONADTALL layouts
@lazy.function
def maximize_by_switching_layout(qtile):
    current_layout_name = qtile.current_group.layout.name
    if current_layout_name == 'monadtall':
        qtile.current_group.layout = 'max'
    elif current_layout_name == 'max':
        qtile.current_group.layout = 'monadtall'

from libqtile import widget
from libqtile.lazy import lazy

def volume_widget():
    return widget.GenPollText(
        update_interval=1,  # refresh every second
        func=lambda: get_volume(),
        mouse_callbacks={
            'Button1': lazy.spawn('pactl set-sink-mute @DEFAULT_SINK@ toggle'),  # left click: mute/unmute
            'Button4': lazy.spawn('pactl set-sink-volume @DEFAULT_SINK@ +5%'),   # scroll up: volume up
            'Button5': lazy.spawn('pactl set-sink-volume @DEFAULT_SINK@ -5%'),   # scroll down: volume down
        }
    )

def get_volume():
    """
    Returns the current volume and mute status as a string.
    """
    import subprocess

    try:
        # Get volume info from pactl
        result = subprocess.run(
            ['pactl', 'get-sink-volume', '@DEFAULT_SINK@'],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        volume_line = result.stdout.splitlines()[0]  # first line
        # Extract the first percentage
        import re
        match = re.search(r'(\d+)%', volume_line)
        if match:
            volume = match.group(1)
        else:
            volume = "N/A"

        # Check mute status
        mute_result = subprocess.run(
            ['pactl', 'get-sink-mute', '@DEFAULT_SINK@'],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        muted = 'yes' in mute_result.stdout.lower()
        if muted:
            return f"🔈 {volume}%"
        else:
            return f"🔊 {volume}%"

    except Exception as e:
        return "Vol N/A"

colors = colors.DoomOne

layout_theme = {"border_width": 2,
                "margin": 12,
                "border_focus": colors[8],
                "border_normal": colors[0]
                }

layouts = [
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Tile(**layout_theme),
    layout.Max(**layout_theme),
    layout.Zoomy(**layout_theme),
]

keys = [
    # =====================================================
    # 1. Essentials / Application Launchers
    # =====================================================
    Key("M-<Return>", lazy.spawn(myTerm), desc="Terminal"),
    Key("M-S-<Return>", lazy.spawn("rofi -show drun -show-icons"), desc="Run Launcher"),
    Key("M-w", lazy.spawn(myBrowser), desc="Web browser"),
    Key("M-b", lazy.hide_show_bar(position="all"), desc="Toggle bar visibility"),
    Key("M-<Tab>", lazy.next_layout(), desc="Toggle between layouts"),
    Key("M-S-c", lazy.window.kill(), desc="Kill focused window"),
    Key("M-S-r", lazy.reload_config(), desc="Reload config"),
    Key("M-S-q", lazy.shutdown(), desc="Shutdown qtile"),
    Key("M-r", lazy.spawncmd(), desc="Spawn command using prompt widget"),
    # =====================================================
    # 2. Window Focus / Navigation
    # =====================================================
    Key("M-h", lazy.layout.left(), desc="Move focus left"),
    Key("M-l", lazy.layout.right(), desc="Move focus right"),
    Key("M-j", lazy.layout.down(), desc="Move focus down"),
    Key("M-k", lazy.layout.up(), desc="Move focus up"),
    Key("M-<space>", lazy.layout.next(), desc="Move focus to other window"),
    # =====================================================
    # 4. Window Resizing (Layout-Specific)
    # =====================================================
    # Key(
    #     "M-=",
    #     lazy.layout.grow_left().when(layout=["bsp", "columns"]),
    #     lazy.layout.grow().when(layout=["monadtall", "monadwide"]),
    #     desc="Grow window left",
    # ),
    # Key(
    #     "M--",
    #     lazy.layout.grow_right().when(layout=["bsp", "columns"]),
    #     lazy.layout.shrink().when(layout=["monadtall", "monadwide"]),
    #     desc="Shrink window / Grow right",
    # ),
    Key("M-C-l", lazy.layout.grow(), desc="Grow window left"),
    Key("M-C-l", lazy.layout.shrink(), desc="Grow window right"),
    Key("M-C-j", lazy.layout.grow_down(), desc="Grow window down"),
    Key("M-C-k", lazy.layout.grow_up(), desc="Grow window up"),
    Key("M-n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key("M-m", lazy.layout.maximize(), desc="Toggle min/max size"),
    # =====================================================
    # 5. Floating / Fullscreen / Minimize
    # =====================================================
    Key("M-t", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key(
        "M-f",
        maximize_by_switching_layout(),
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen",
    ),
    Key("M-S-m", minimize_all(), desc="Toggle hide/show all windows on current group"),
]

defaultLayout = "monadtall"
groups = [
    Group(
        name = "1",
        layout = defaultLayout,
        label = "",
    ),
    Group(
        name = "2",
        layout = defaultLayout,
        label = "",
        matches = [
            Match(wm_class="qutebrowser"),
            Match(wm_class="brave-browser"),
            Match(wm_class="google-chrome"),
        ]
    ),
    Group(
        name = "3",
        layout = defaultLayout,
        label = "",
    ),
    Group(
        name = "4",
        layout = defaultLayout,
        label = "",
        matches = [
            Match(wm_class="mpv")
        ]
    ),
    Group(
        name = "5",
        layout = defaultLayout,
        label = "",
    ),
]
# group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

# Uncomment only one of the following lines
# group_labels = ["", "", "👁", "", "", "", "✀", "꩜", "", "⎙"]
#group_labels = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
# group_labels = ["DEV", "WWW", "SYS", "DOC", "VBOX", "CHAT", "MUS", "VID", "GFX", "MISC"]

# The default layout for each of the 10 workspaces
# group_layouts = ["monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall"]

# for i in range(len(group_names)):
#     groups.append(
#         Group(
#             name=group_names[i],
#             layout=group_layouts[i].lower(),
#             label=group_labels[i],
#         ))

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                "M-"+i.name,
                # [mod],
                # i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = move focused window to group
            Key(
                "M-S-"+i.name,
                # [mod, "shift"],
                # i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc="Move focused window to group {}".format(i.name),
            ),
        ]
    )

widget_defaults = dict(
    font="Ubuntu Bold",
    fontsize = 12,
    padding = 0,
    background=colors[0]
)

extension_defaults = widget_defaults.copy()

def init_widgets_list():
    widgets_list = [
        widget.Spacer(length = 8),
        widget.Prompt(
            font = "Ubuntu Mono",
            fontsize = 14,
            foreground = colors[1]
        ),
        widget.GroupBox(
            fontsize = 14,
            margin_y = 5,
            margin_x = 14,
            padding_y = 0,
            padding_x = 2,
            borderwidth = 3,
            active = colors[8],
            inactive = colors[9],
            rounded = False,
            highlight_color = colors[0],
            highlight_method = "line",
            this_current_screen_border = colors[7],
            this_screen_border = colors [4],
            other_current_screen_border = colors[7],
            other_screen_border = colors[4],
            # hide_unused = True,
        ),
        widget.TextBox(
                 text = '|',
                 font = "Ubuntu Mono",
                 foreground = colors[9],
                 padding = 2,
                 fontsize = 14
                 ),
        widget.CurrentLayout(
                 foreground = colors[1],
                 padding = 5,
                 mode = "icon",
                 icon_first = "True",
                 ),
        widget.TextBox(
                 text = '|',
                 font = "Ubuntu Mono",
                 foreground = colors[9],
                 padding = 2,
                 fontsize = 14
                 ),
        widget.WindowName(
                 foreground = colors[6],
                 padding = 8,
                 max_chars = 40
                 ),
        # volume_widget(),
        EventVolume(),
        widget.TextBox(
                 text = '|',
                 font = "Ubuntu Mono",
                 foreground = colors[9],
                 padding = 2,
                 fontsize = 14
                 ),
        widget.Clock(
                 foreground = colors[8],
                 padding = 8,
                 mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('notify-date')},
                 ## Uncomment for date and time
                 format = "⧗  %a, %b %d - %H:%M",
                 ## Uncomment for time only
                 # format = "⧗  %I:%M %p",
                 ),
        widget.Spacer(length = 8),
    ]
    return widgets_list

screens = [
    Screen(
        top = bar.Bar(
            init_widgets_list(),
            background = "#00000000",
            size = 24,
        )
    )
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    border_focus=colors[8],
    border_width=2,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),   # gitk
        Match(wm_class="dialog"),         # dialog boxes
        Match(wm_class="download"),       # downloads
        Match(wm_class="error"),          # error msgs
        Match(wm_class="file_progress"),  # file progress boxes
        Match(wm_class='kdenlive'),       # kdenlive
        Match(wm_class="notification"),   # notifications
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
