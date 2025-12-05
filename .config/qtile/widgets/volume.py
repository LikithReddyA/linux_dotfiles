from libqtile import widget
import subprocess
import threading
import re

class EventVolume(widget.base.ThreadPoolText):
    """
    Event-driven volume widget using `pactl subscribe`.
    Supports:
        - Left click : mute/unmute
        - Scroll up  : volume +5%
        - Scroll down: volume -5%
    """
    orientations = widget.base.ORIENTATION_HORIZONTAL
    defaults = [
        ("font", "Ubuntu Mono", "Font for the widget"),
        ("fontsize", None, "Font size"),
    ]

    def __init__(self, **config):
        super().__init__(**config)
        self.add_defaults(self.defaults)
        self.update_volume()  # initialize
        threading.Thread(target=self.listen_events, daemon=True).start()

    def listen_events(self):
        try:
            process = subprocess.Popen(
                ["pactl", "subscribe"],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True
            )
            for line in process.stdout:
                if "sink" in line:
                    self.update_volume()
        except Exception:
            pass

    def update_volume(self):
        try:
            result = subprocess.run(
                ["pactl", "get-sink-volume", "@DEFAULT_SINK@"],
                stdout=subprocess.PIPE, text=True
            )
            match = re.search(r"(\d+)%", result.stdout)
            volume = int(match.group(1)) if match else 0

            mute_result = subprocess.run(
                ["pactl", "get-sink-mute", "@DEFAULT_SINK@"],
                stdout=subprocess.PIPE, text=True
            )
            muted = "yes" in mute_result.stdout.lower()

            # Ubuntu Mono–compatible icons
            if muted or volume == 0:
                icon = "🔈"
                color = "#ff5555"
            else:
                icon = "🔊"
                color = "#a6e3a1"

            new_text = f'<span foreground="{color}">{icon} {volume}%</span>'
            # 🔥 THIS triggers redraw correctly
            self.update(new_text)
        except Exception:
            self.update('<span foreground="#ff0000">Vol N/A</span>')

    def button_press(self, x, y, button):
        try:
            if button == 1:
                subprocess.run(["pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle"])
            elif button == 4:
                subprocess.run(["pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%"])
            elif button == 5:
                subprocess.run(["pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%"])
            self.update_volume()
        except Exception:
            pass
