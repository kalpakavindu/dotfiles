#!/usr/bin/env python3
# Written by KalpaKavindu <kalpadevonline@gmail.com>

import subprocess
from gi.repository import Nautilus, GObject


class TerminalMenuProvider(GObject.GObject, Nautilus.MenuProvider):
    def __init__(self):
        pass
    
    def open_in_alacritty(self, menu, file):
        filepath = file.get_location().get_path()
        subprocess.Popen(["alacritty", "--working-directory", filepath])

    def open_current_in_alacritty(self, menu, folder):
        filepath = folder.get_location().get_path()
        subprocess.Popen(["alacritty", "--working-directory", filepath])

    # Context menu item for Directories
    def get_file_items(self, files):
        if len(files) != 1 or not files[0].is_directory():
            return []

        item = Nautilus.MenuItem(
            name="TerminalExt::open_in_alacritty",
            label="Open in Terminal",
            tip="Open folder in Alacritty",
        )

        item.connect("activate", self.open_in_alacritty, files[0])
        return [item]

    # Context menu item for Empty space
    def get_background_items(self, current_folder):
        item = Nautilus.MenuItem(
            name="TerminalExt::open_current_in_alacritty",
            label="Open in Terminal",
            tip="Open folder in Alacritty",
        )

        item.connect("activate", self.open_current_in_alacritty, current_folder)
        return [item]
