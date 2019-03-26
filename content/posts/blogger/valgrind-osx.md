---
title: 'valgrind + osx'
date: 2011-04-16T12:18:00.000+02:00
draft: false
tags : [testing, 10.6, valgrind]
authors: [mathias]
---

# valgrind + OSX

I just started implementing unit tests for my hobby project and I wanted to integrate [valgrind](http://www.valgrind.org/) into my testing process, especially since it recently got fully supported on OSX. So I tried the MacPorts installation of the package.

Unfortunately, I run a 10.6 64-bit os and so the packages that are automatically built come out as x86_64 executables. But in my hobby project, I keep everything 32bit. And even though the valgrind [documentation](http://valgrind.org/docs/manual/manual-core.html#manual-core.install) indicates that it should work with both 32 bit and 64 bit executables, I couldn't get it to work. It just produced errors like:

    valgrind: ./a.out: cannot execute binary file

So, my current solution is that I've downloaded the source and compiled it with only 32 bit support. Instructions are found [here](http://valgrind.org/downloads/repository.html) with the change:

    ./configure --enable-only32bit

And I keep the working 64 bit version available so I can still test all executables.

If anyone knows what I should do to get both 32 / 64 bit support in the same valgrind executable, please let me know!