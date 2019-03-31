---
title: 'Arduino + NodeMCU / ESP8266'
date: 2017-08-30T18:50:00.000+02:00
draft: false
authors: [mathias]
categories: [notes]
tags: [arduino]
---

To program for the ESP8266, you need to install some packages for the Arduino program/computer.

To add the ESP boards to the board list in Arduino, you
*   Add the line http://arduino.esp8266.com/stable/package\_esp8266com\_index.json into the preferences pane, in the "Additional Boards Manager URLs"
*   Then open Tools -> Board -> Boards Manager and install **ESP8266**

You can now select your proper board from the list.

Next, you need to make sure you can select the proper port it's connected to. To do that, you install the driver from [here](https://www.silabs.com/products/development-tools/software/usb-to-uart-bridge-vcp-drivers)

Then, you choose the port named "/dev/cu.SLAB_USBtoUART"

Now you're ready to build and upload as usual for your NodeMCU board!

Sources:
https://github.com/esp8266/Arduino
http://www.instructables.com/id/Quick-Start-to-Nodemcu-ESP8266-on-Arduino-IDE/
https://roboindia.com/tutorials/nodemcu-amica-esp8266-board-installation