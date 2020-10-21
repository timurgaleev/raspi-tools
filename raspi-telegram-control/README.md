# RASPI TELEGRAM CONTROL

Python based Telegram bot to monitor and control the raspberry pi.

## Setting up the bot
- Install telepot library for enabling the Raspberry Pi to communicate with the Telegram bot using the API.
  ```
  sudo pip3 install telepot
  ```
- Request the BotFather to create a new Bot.
- Paste the HTTP access token here (in the code):
  ```
  bot = telepot.Bot('  TELEGRAM TOKEN  ')
  ```
 - Run *control-pi.py* as sudo 
 - Try out the commands given below in the Telegram bot chat (see Usage section below)
 - GPIO of led1 and led2 set as 5 and 10 respectively(BCM numbering).
## Commands:


- help - List of commands
- ledon1 - Switch on LED 1
- ledoff1 - Switch off LED 1
- ledon2 - Switch on LED 2
- ledoff2 - Switch off LED 2
- cpu - Get CPU info (lscpu)
- usb - See connected USB devices (lsusb)
- ping - To check if online
- time - Returns time
- date - Returns date
- temp - CPU Temperature
- repoupdate - update repositories (sudo apt-get update)
- upgrade - upgrade packages (sudo apt-get upgrade -y)
- shutdown - Shutdown RPi (sudo shutdown -h now)
- reboot - Reboot RPi (sudo reboot)

## Usage:
- Use ' / ' before each command
- Example: To check the CPU Temperature;
 ```
 /temp
 ```
## Tips:
- See more about telegram bots here: https://core.telegram.org/bots
- As the /repoupdate and /upgrade takes time you can use /ledon1 or /ledon2 command to alert you when the process is complete.




# How to Setup Python Script Autorun As a Service in Ubuntu 

Move your file in /opt/control-pi/raspi-control.py

## Create Service File
The file must have .service extension under /lib/systemd/system/ directory

```
$ sudo vi /lib/systemd/system/raspi-control.service
```
## Add some contant with python full path and description

```
[Unit]
Description=Test Service
After=multi-user.target
Conflicts=getty@tty1.service

[Service]
Type=simple
ExecStart=/usr/bin/python3 /opt/control-pi/raspi-control.py
StandardInput=tty-force

[Install]
WantedBy=multi-user.target
```

## Enable Newly Added Linux Service
Reload the systemctl daemon to read new file. You need to reload this deamon each time after making any changes in in .service file.

```
$ sudo systemctl daemon-reload
```

## Now enable and start your new service

```
$ sudo systemctl enable raspi-control.service
$ sudo systemctl start raspi-control.service
```

## For service status:

```
$ sudo systemctl status raspi-control.service
```