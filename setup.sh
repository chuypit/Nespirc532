#!/bin/bash
# RetroPi Control Install
CURRENT=`pwd`
PARENT=`dirname $CURRENT`
SCRIPTS='/home/pi/scripts'
#start install
echo "**************************************"
echo "Installing Nespi532"
echo "**************************************"
echo -n "**************************************"
echo -n "Warning!!! Installing the Pi Control Board on the incorrect pins on the Pi can damage your Pi!"
echo "Please use Pi Control Hardware and Software at your own risk. We do not take responsibility for any damages to your raspberry pi that may occure."
echo "By downloading and installing our hardware and software you are agreeing to these terms."
echo "**************************************"
echo -n "Would you like to continue with the installation? (y/n): "
read REPLY
if [ $REPLY = "y" ] || [ $REPLY = "Y" ]
then
    echo "**************************************"
    echo "Installing NFC "
    apt-get install -y python-dev python-pip git
    git clone https://github.com/adafruit/Adafruit_Python_PN532.git
    cd Adafruit_Python_PN532
    python setup.py install
    cd ../
    rm -R Adafruit_Python_PN532
    echo "Enabling Serial Interface............."
    #echo 'enable_uart=1' >> /boot/config.txt
    sed -i '\:enable_uart=0:d' /boot/config.txt 
    sed -i '\:enable_uart=1:d' /boot/config.txt
    echo 'enable_uart=1' >> /boot/config.txt
    #update startup
    echo "Updating Startup Commands............."
    sed -i '\:emulationstation #auto:d' /opt/retropie/configs/all/autostart.sh
    sed -i '\:emulationstation:d' /opt/retropie/configs/all/autostart.sh
    sed -i '\:python /home/pi/Nespirc532/v4.py 2>&1:d' /opt/retropie/configs/all/autostart.sh
    echo 'python /home/pi/Nespirc532/v4.py 2>&1' >> /opt/retropie/configs/all/autostart.sh
    echo 'emulationstation' >> /opt/retropie/configs/all/autostart.sh
    echo "Installation Complete................."
    echo -n "You must reboot for changes to take effect, reboot now? (y/n): "
    read REPLY
    if [ $REPLY = "y" ] || [ $REPLY = "Y" ]
    then
        sleep 3
    fi
fi

cd /etc/
RC=rc.local

if grep -q "sudo python \/home\/pi\/Nespirc532\/button.py \&" "$RC";
	then
		echo "File /etc/rc.local already configured. Doing nothing."
	else
		sed -i -e "s/^exit 0/sudo python python \/home\/pi\/Nespirc532\/button.py \&\n&/g" "$RC"
		echo "File /etc/rc.local configured."
fi

echo "Will now reboot after 3 seconds."
sleep 3
sudo reboot
#end