#/bin/bash
export DISPLAY=:0.0
rm "screenshot_shave_old.png"
rm "screenshot.png"
mv "screenshot_shave.png" "screenshot_shave_old.png"
scrot "screenshot.png"
convert "screenshot.png" -strip -background skyblue -extent  1920x800 "screenshot_shave.png"

DI=$(diff screenshot_shave_old.png screenshot_shave.png)
if [ "$DI" != "Binärdateien screenshot_shave_old.png und screenshot_shave.png sind verschieden." ]
then
        /usr/sbin/ifconfig wg0 | grep 'inet' > /home/pi/message.txt
        echo 'REFRESH' >> /home/pi/message.txt
        mpack -s "DISPLAY_NAME" -d /home/pi/message.txt /home/pi/screenshot_shave.png auskunft@nvv.de
        ./refresh.sh;
        echo "REFRESH";
else
        echo $DI
fi
