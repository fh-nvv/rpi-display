#!/bin/bash

xset s off
xset -dpms
xset s noblank

unclutter &

matchbox-window-manager &

# WICHTIG: exec damit Session sauber bleibt
exec chromium --start-fullscreen "https://auskunft.nvv.de/mct/views/monitor/?cfgFile=zY3dFQ94lrozxUbamGNv_1561622679541&station=2205454&productOrder=[1,2,4,1024,32,192]"
