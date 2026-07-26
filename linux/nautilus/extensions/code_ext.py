#!/usr/bin/env python3
# Written by KalpaKavindu <kalpadevonline@gmail.com>

import subprocess
from gi.repository import Nautilus, GObject


class CodeMenuProvider(GObject.GObject, Nautilus.MenuProvider):
    def __init__(self):
        pass
    
    def open_in_code(self, menu, file):
        filepath = file.get_location().get_path()
        subprocess.Popen(["code", "-n", filepath])

    def open_current_in_code(self, menu, folder):
        filepath = folder.get_location().get_path()
        subprocess.Popen(["code", "-n", filepath])

    # Context menu item for Directories
    def get_file_items(self, files):
        if len(files) != 1:
            return []

        item = Nautilus.MenuItem(
            name="CodeExt::open_in_code",
            label="Open in Code",
            tip="Open in Visual Studio Code",
        )

        item.connect("activate", self.open_in_code, files[0])
        return [item]

    # Context menu item for Empty space
    def get_background_items(self, current_folder):
        item = Nautilus.MenuItem(
            name="CodeExt::open_current_in_code",
            label="Open in Code",
            tip="Open folder in Visual Studio Code",
        )

        item.connect("activate", self.open_current_in_code, current_folder)
        return [item]
