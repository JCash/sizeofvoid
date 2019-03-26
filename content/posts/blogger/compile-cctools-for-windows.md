---
title: 'Compile cctools for Windows'
date: 2018-12-01T12:46:00.001+01:00
draft: false
tags : [ipa, OSX, macOS, cctools, windows, lipo, strip, Win64, Win32]
authors: [mathias]
---

I wanted to try building cctools for Windows,

I first tried (and failed) with [cctools-port](https://github.com/tpoechtrager/cctools-port)
Next, I tried (and succeeded) with [osxcross](https://github.com/tpoechtrager/osxcross) and Cygwin (32 and 64 bit).

Also note that I needed no iOS/OSX SDK for this!

Here's a brief recap on what I had to do...

### Cygwin

Install [Cygwin](https://cygwin.com/install.html) (either 32 or 64 bit)

After launching the Cygwin setup tool, install these packages.
Note that I tried to keep the list as clean as possible, but I _did_ have to iterate on it, so it might contain something redundant. I kept the version numbers I got at the time of writing.

*   autoconf                  (13-1)
*   automake                (10-1)
*   cmake                     (3.6.2-1)
*   gcc-core                  (7.3.0-3)
*   gcc-g++                   (7.3.0-3)
*   gcc-objc                  (7.3.0-3)
*   gcc-objc++              (7.3.0-3)
*   git                           (2.17.0-1)
*   make                        (4.2.1-2)
*   openssl-devel           (1.0.2p-1)
*   libtool
*   libiconv-devel        (1.14-3)
*   python2                   (2.7.14-1)

### Osxcross

Clone [osxcross](https://github.com/tpoechtrager/osxcross) into a directory and **cd** there.

Now, download the patch (some structs are already defined in cygwin) and put in the **patches/** folder.
[cctools-dlfcn.patch](https://gist.github.com/JCash/8a156717494d3259ca38ee8d75630a3e)

Then, run the cctools part of the original osx_cross.sh, with the added patch:
[osx_cross.sh](https://gist.github.com/JCash/dacbf43d49a68790d52b7d668c0c0d1a)

Now, you should have a set of tools ready for use on your machine!