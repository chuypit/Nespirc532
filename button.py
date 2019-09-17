import sys, os, time, json, subprocess
import RPi.GPIO as GPIO
import nfc532 as nfc
import ndef532 as ndef

#setup GPIO
gpioReset = 18
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
#setup the reset button
GPIO.setup(gpioReset, GPIO.IN, GPIO.PUD_UP)

#loop the button controls
while True:
    try:
        if GPIO.input(gpioReset) == False:
           
            timer = 0
            # we held the reset button then we want to write to the nfc, else we reset the rom
            while timer < 2.0:
                if GPIO.input(gpioReset) == False:
                    os.system("sudo killall emulationstation && sleep 0s && sudo openvt -c 1 -s -f emulationstation 2>&1")
                else:
                    os.system("sudo killall retroarch && sudo emulationstation")

                    break
                
                time.sleep(.1)
            

            
                


            
    except:
        pass
                   
    time.sleep(.1)
