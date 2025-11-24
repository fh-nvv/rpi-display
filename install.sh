#!/bin/bash
sudo apt update
sudo apt dist-upgrade -y
sudo apt install firefox firefox-l10n-de x11-xserver-utils unclutter matchbox-window-manager wireguard xdotool openbox xserver-xorg mosquitto-clients xinit scrot mpack ssmtp -y

# adds startup scripts to bash
echo "
#NVV Start & Stop:
temp=\$(tty);

if [ \${temp:5} == \"tty1\" ]; then
    /home/nvv/mqtt.sh & disown;
    /home/nvv/startAnzeige.sh;
else
    echo "NVV System";
fi" >> .bashrc

# swaps placeholders for values in display.conf

display_name_param=$1

# formats the url, & is used in regex
display_url_param=$(echo "$2" | sed 's|&|\\&|g')

sed -i "s|DISPLAY_NAME|$display_name_param|g" check_refresh.sh
sed -i "s|DISPLAY_URL|$display_url_param|g" anzeige.sh
