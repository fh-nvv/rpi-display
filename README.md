# rpi-display

Hier sind die Config-Files für ein Raspberry Pi (RPi) Display hinterlegt.

## Anleitung zum Aufsetzen eines RPi Display

0. per SSH verbindung zu RPi aufbauen
1. sudo raspi-config und auf CLI+Autologin stellen (B1 -> S6). Ggf. noch anderen Sachen verändern.
2. skripte auf RPi in /home/nvv/ übertragen, bspw. mit scp (`wg-configs` **sollten ignoriert werden hier**)
```
scp .\{rpi-display-repo}\* nvv@192.168.YYY.XXX:/home/nvv/
```

3. berechtigungen fürs Verzeichnis setzen
```
chmod -R 777 ./
```

4. install.sh ausführen, bspw. für Bahnhof Bebra
```
install.sh "Display Bahnhof Bebra" "https://auskunft.nvv.de/mct/views/monitor/index.html?cfgFile=InSMKOpD1JmPGpTZXTTN_1637768804978"
```

4a. bei veralteten Geräten auch das Betriebssystem update
```
sudo rpi-upgrade
```

5. folgende Befehle ausführen
```
crontab ./crontab.conf
```

6. reboot

7. in  `~/.mozilla/firefox/*.default-release/prefs.js` folgende Zeilen einfügen (deaktiviert die Sidebar), **erst wenn firefox einmal gestartet wurde**
```
user_pref("sidebar.revamp", false);
user_pref("sidebar.visibility", "hide-sidebar");
```

8. kopiere relevante wireguard config nach `/home/nvv`, **sudo berechtigung notwendig**
```
scp .\{rpi-display-repo}\wg-configs\{wg-dpi-XX} nvv@192.168.YYY.XXX:/home/nvv/
```
anschließend als `wg6.conf` ins `/etc/home/`
```
sudo mv ./wg-dpi-XX /etc/wireguard/wg6.conf
```

9. wireguard config einstellen
```
wg-quick up wg6
```

10. wireguard service einstellen
```
sudo systemctl enable wg-quick@wg6
```
testbar über bspw. `ping`, packets sollten rausgehen
```
ping 10.10.10.1
```

11. smtp conf einrichten, `ssmtp.conf` ist nicht im repo vorhanden. Jasper oder Fabian sollten die haben. **Optional**, wenn bereits in Schritt 2 kopiert
```
scp .\{path-to-conf}\ssmtp.conf nvv@192.168.YYY.XXX:/home/nvv/
sudo mv ./ssmtp.conf /etc/ssmtp/ssmtp.conf
```

12. reboot oder shutdown, ab hier fertig konfiguriert

## WLan aufsetzen

1. interface entblocken, wobei X die jeweilige Interface-ID ist **default 1** 
```
sudo rfblock unblock X
```

2. interface öffnen
```
sudo ifconfig wlan0 up
```

3. über raspi-config konfigurieren (B1->S1)

4. überprüfen, ob die Konfiguration funktioniert hat
```
ip a
```