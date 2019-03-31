---
title: 'Command line Arduino builds'
date: 2017-05-28T11:55:00.000+02:00
draft: false
authors: [mathias]
categories: [notes]
tags: [arduino]
---

Now that I have the Arduino up and running, I knew I wanted to use my editor of choice and command line build tools.

There is of course the alternative of using the Arduino IDE as a [command line tool](https://github.com/arduino/Arduino/blob/master/build/shared/manpage.adoc), but it still felt too clunky for my needs.

Secondly, there is the [Arduino Makefile project](https://github.com/sudar/Arduino-Makefile), which would be a better fit, was it not... you know... make. And I saw a few results for CMake when googling, don't get me started.

So, again, I set out to create my first built scripts.
I looked at [these instructions](http://maxembedded.com/2015/06/setting-up-avr-gcc-toolchain-on-linux-and-mac-os-x/) and changed it slightly for my needs. I also [looked here](http://thinkingonthinking.com/an-arduino-sketch-from-scratch/).



    $ brew tap osx-cross/avr$ brew install avr-libc avr-gdb$ brew install avrdude --with-usb


After that, I looked at the verbose output from the Arduino IDE to figure out most settings. And I also compared them to other packages (Arduino-make etc).

In the end, I got this [build.sh](https://github.com/JCash/arduino-kitchentimer/blob/master/build.sh)

#### Monitor

To communicate with the Arduino (e.g. displaying the debug output), I use "screen" on osx (On windows there's PuTTY).

You quit "screen" with ^A+K:


    $ screen /dev/cu.wchusbserial1410 9600



#### Foot note:

I compared the turnaround time between my script and Arduino-make:

_./build.sh:_


    $ time ./build.shreal 0m3.264suser 0m0.185ssys 0m0.100s


_Arduino-make:_


    $ time (make -f ../Makefile && make -f ../Makefile verify_size reset do_upload)real 0m6.275suser 0m1.224ssys 0m1.120s

That's 3 seconds longer. That's going to get annoying real fast! Of course you get a ton of extra features, but I just don't need them.