---
title: 'iPhone Simulator + unittests'
date: 2011-04-20T00:31:00.000+02:00
draft: false
tags : [testing, iPhone]
authors: [mathias]
---

I just recently added the [google test framework](http://code.google.com/p/googletest/) to my code and when doing so I also had may aims set at making sure I got it working on as many platforms as possible. First out was testing on OSX which worked fine and from there the next step was adding support for the iphone simulator.  
  
Making it [gtest](http://code.google.com/p/googletest/) compile for iphone/simulator wasn't anymore trouble some than compiling other libraries cross platform. Instead, the trouble came when trying to execute the compiled tests through the simulator.  
  
  
  
At a previous occasion, I had tried (unsuccessfully) to build and execute my entire project with the help of my own build system (which is built upon [waf](http://code.google.com/p/waf/)). I just couldn't get the executable to start. Since then I found [this](http://stackoverflow.com/questions/1187611/how-to-install-iphone-application-in-iphone-simulator) link giving me the option to launch my executable explicitly:  

```bash
    $ <path to simulator> -SimulateApplication <path to my executable>
```
  
That works, but it launches the springboard and that means that the application won't quit like you'd expect: when you return from your main-function, the application will simply be respawned.  
  
Instead, I looked into some other frameworks to see how they achieve this. Perhaps the most famous one is the Google Testing Framework. That package has a [RunIPhoneTest.sh](http://www.google.com/codesearch/p?hl=en#NX45eFlAhC0/trunk/UnitTesting/RunIPhoneUnitTest.sh&q=RunIPhoneUnitTest.sh%20package:http://google-toolbox-for-mac%5C.googlecode%5C.com&sa=N&cd=1&ct=rc) which contains some clues.  
Another clue can be found in GH-Unit that contains a [RunTests.sh](https://github.com/gabriel/gh-unit/blob/master/Scripts/RunTests.sh) which is less cluttered.  
  
In the end, it was all very simple. Set the DYLD\_ROOT\_PATH to the simulator sdk choice.  
This lets you run your executable from your command line in a straight forward manner.  
  
Here's a quick example.  
  
First, save your your code into test.cpp:  
  
```cpp
#include <stdio.h>
int main(int argc, char** argv) {
    for( int i = 0; i < argc; ++i )
        printf("Arg %d: %s\\n", i, argv\[i\]);
    return 0;
}
```
  
Compile this with:  

```bash
/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/g++ -arch i386 -m32 -Wall -isysroot /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator4.3.sdk test.cpp -o a.out -framework OpenGLES  
```
I added the OpenGLES framework merely to demonstrate that this test works.
  
Save your environment settings into a bash script runsim.sh:  
```bash
#!/bin/sh  
export DYLD\_ROOT\_PATH=/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator4.3.sdk  
#runs the executable  
$@  
unset DYLD\_ROOT\_PATH  
```
  
Make the script executable:  

```bash
$ chmod +x runsim.sh
```

Now you should be able to run your executable with:  

```bash
$ ./runsim.sh a.out
```
  
And the expected output is:  

```bash
$ ./a.out
```
