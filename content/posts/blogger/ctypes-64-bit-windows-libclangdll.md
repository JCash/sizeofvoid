---
title: 'ctypes + 64 bit windows + libclang.dll'
date: 2012-05-25T19:13:00.001+02:00
draft: false
tags : [64 bit, windows, Python, clang, ctypes]
---

This post is mostly for my own reference for the future.  
  
I ran into trouble when using clang with 64 bit ctypes on a windows machine. Apparently there's a [bug](http://bugs.python.org/issue11835%20) reported on the issue.  
  
On windows, the compiler will convert arguments larger than 8 bytes into references automatically, whereas ctypes just happily allocates memory for the stack, ignoring the this fact. That leads to crashes.  
  
I tried recompiling the _ctypes.pyd file, but that only caused my Python to hang. So, until that bug is fixed, I have to use the POINTER construct in ctypes instead.  
  
The guys implementing the [Sublime autocompletion plugin](https://github.com/quarnster/SublimeClang/issues/3) has solved it this way: [cindex.py](https://gist.github.com/1658637)