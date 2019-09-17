import sys, os, time, json, ConfigParser
import RPi.GPIO as GPIO
import subprocess
import nfc532 as nfc



def kill_by_process_name_shell(name):
    os.system("taskkill /f /im " + name)
 

## getEmulatorPath
def getEmulatorpath(console):
    path = "/opt/retropie/supplementary/runcommand/runcommand.sh 0 _SYS_ " + console + " "
    return path

## getGamePath
def getGamePath(console, game):
    game = game.replace(" ", "\ ")
    game = game.replace("(", "\(")
    game = game.replace(")", "\)")
    game = game.replace("'", "\\'")
    gamePath = "/home/pi/RetroPie/roms/" + console + "/" + game
    return gamePath

os.system('pkill -9 -f button.py')

subprocess.Popen('python /home/pi/Nespi/button.py&', shell=True)    



response = nfc.read()
            
if response.type == 'success':
    message = response.data

    gel = getEmulatorpath(message.records[0].value)
    dol = getGamePath(message.records[0].value, message.records[1].value)
          
    subprocess.call(gel + dol, shell=True)    
else:
    
     print("cargando emulationstation")


   
    
