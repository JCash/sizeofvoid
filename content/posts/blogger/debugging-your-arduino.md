---
title: 'Debugging your arduino'
date: 2017-05-31T00:56:00.000+02:00
draft: false
tags : [debugging, gdb, arduino]
authors: [mathias]
---

While I'm waiting for my first OLED screen to arrive, I decided to learn more about the debugging options available for the Arduino.

I found 4 alternatives:


*   Hardware
*   Emulators
*   Print
*   Drivers


In the end the option most attractive to me at this point is to add debugging drivers to my code.
But I'll list the other options first...


### Hardware:

There are a few variants out there, costing ctom $10-$100+:
Atmega328P Xplained Mini, AVR Dragon, JTAGICE2, AVR One, JTAGICE3

The cheapest one is the Atmega328P Xplained Mini at ~$10. Unfortunately, it seems very tied to the Atmel Studio which is only supported on Windows.


### Emulators:

I found 2 emulators, each with similar feature sets, but one seems a bit legacy at this point:


*   [Simulavr](http://savannah.nongnu.org/projects/simulavr) \- [git](http://savannah.nongnu.org/projects/simulavr) (legacy) - [howto](http://reprap.org/wiki/SimulAVR)
*   [Simavr - git](https://github.com/buserror/simavr)


Both emulators have the option to sample the output pins, and log the values into a .vcd file, which can be displayed with **gtkwave**.


### Print:

It's of course important to mention that you _can_ do print debugging too when you need it



### Drivers:

After stumbling across [this post](https://www.codeproject.com/Articles/1037057/Debugger-for-Arduino) by Jan Dolinay, I wanted to see it it worked for my cheap arduino.
I turned out it was farily easy to build it. There was a few caveats (mentioned by Jan in his post) regarding the serial interface, but in essence, you cannot use the Serial class since the debugger uses the serial port. But there is a **debug_message(const char* msg)** that can be used instead.


#### Build notes:



*   Add the **[avr8-stub.c](https://github.com/jdolinay/avr_debug/blob/master/avr8-stub/avr8-stub.c)** to your build, add **[avr8-stub.h](https://github.com/jdolinay/avr_debug/blob/master/avr8-stub/avr8-stub.h)** to your main.cpp
*   Overwrite the **[WInterrupts.c](https://github.com/jdolinay/avr_debug/blob/master/arduino/1.8.1/WInterrupts.c)** in your core library
*   Call **debug_init()** in your setup() function
*   [Optional] Set programmatic breakpoints using **breakpoint()**
*   Add flags "-Og" and "-gdwarf-2"

#### Debugging:

Once you've built the .hex file and uploaded it, it's time to run **avr-gdb**:

*   Upload the myprog.hex file with **avrdude**
*   Run debugger with, connecting to your serial port:

*   avr-gdb -ex "target remote /dev/cu.wchusbserial1410" -b 115200 myprog.elf

And, that's it! Now you can debug using breakpoints as usual.



Happy Debugging!