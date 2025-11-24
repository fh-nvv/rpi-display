#!/bin/bash
export DISPLAY=:0.0
rm "screenshot.png"
scrot -m "screenshot.png"
/usr/sbin/ifconfig wg6 | grep 'inet' > /home/nvv/message.txt
/usr/sbin/ifconfig eth0 | grep 'inet' >> /home/nvv/message.txt
mpack -s $HOSTNAME -d /home/nvv/message.txt /home/nvv/screenshot.png auskunft@nvv.de
