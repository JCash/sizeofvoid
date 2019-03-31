---
title: 'My first Arduino'
date: 2017-05-24T00:15:00.002+02:00
draft: false
tags : [arduino]
authors: [mathias]
categories: [notes]
---

I recently got hooked by the game [Shenzhen I/O](http://store.steampowered.com/app/504210/SHENZHEN_IO/) which I've played and enjoyed a lot with my friends. And, after a while, I got curious about learning some (really) simple electronics. So I picked up a subscription to [TronClub](http://tronclub.com/). But, after a little while, my coding brain wanted to skip to the fun stuff: Creating something that was really working and useful in very few bytes, and also to get to do some soldering!

So, I got onto [www.aliexpress.com](https://www.aliexpress.com/wholesale?catId=400103&initiative_id=AS_20170523140652&SearchText=arduino+uno) and ordered some components, first of which arrived today was my [new Arduino Uno](https://www.aliexpress.com/item/Free-shipping-UNO-R3-MEGA328P-for-Arduino-Compatible-with-USB-cable-and-9V-battery-clip-snap/1960629582.html?spm=2114.13010608.0.0.Y7yZy1) (or rather a $3 knock off from China). Installing the Arduino IDE was simple enough, but getting it to talk to my arduino was not so simple.

[![](https://4.bp.blogspot.com/-OXNm3IjHU80/WSS0H_ocWeI/AAAAAAAAC3k/YHcTMURA0PovgNLijePlm8vR1Zr7kTxoQCLcB/s320/Screen%2BShot%2B2017-05-24%2Bat%2B00.12.44.png)](https://4.bp.blogspot.com/-OXNm3IjHU80/WSS0H_ocWeI/AAAAAAAAC3k/YHcTMURA0PovgNLijePlm8vR1Zr7kTxoQCLcB/s1600/Screen%2BShot%2B2017-05-24%2Bat%2B00.12.44.png)

I'm using a mac, and those security settings can be a little bit in the way sometimes. In this case, it seems the USB protocols didn't support the china boards usb chips. Luckily, after much hassle (I won't mention those details, to not confuse the instructions for you), I found this driver that worked for me, by just installing:

[https://blog.sengotta.net/signed-mac-os-driver-for-winchiphead-ch340-serial-bridge/](https://blog.sengotta.net/signed-mac-os-driver-for-winchiphead-ch340-serial-bridge/)

After installation, I rebooted and restarted the Arduino IDE, and now, voilà, the "Tools -> Ports -> Serial Ports" lists "/dev/cu.wchusbserial1420" as a proper port. And now I can upload new sketches.