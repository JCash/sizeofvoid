---
title: 'Get the default include paths from Clang'
date: 2018-12-02T14:16:00.000+01:00
draft: false
tags : [OSX, Linux, macOS, gcc, SSE4.2, xmmintrin.h, intrinsics, intrin.h, clang, Win32, SSE]
authors: [mathias]
---


When porting our code to build for Win32 with Clang, on macOS, I got a bunch of intrinsics errors:

```cpp
/usr/local/opt/llvm/bin/lld-link: **error:** dlib.lib(image_2.o): undefined symbol: __cpuid
/usr/local/opt/llvm/bin/lld-link: **error:** dlib.lib(image_2.o): undefined symbol: _mm_setr_epi16
/usr/local/opt/llvm/bin/lld-link: **error:** dlib.lib(image_2.o): undefined symbol: _mm_set1_epi32
/usr/local/opt/llvm/bin/lld-link: **error:** dlib.lib(image_2.o): undefined symbol: _mm_load_si128
```


This error is a bit unusual (for me at least) so it threw me off, since I had obviously linked against the dlib.lib before, only difference, it was using CL.exe at that time.

This isn't due to a missing library, but in fact a missing include.
And as it turns out, _the order_ of includes.

The compiler checks the include file(s) to see what symbols to put in there, and if it recognises it, it outputs the correct intrinsic function in the code. Otherwise, it's unresolved, and will later become undefined.

And, in order to make the code a bit more resilient towards compiler version updates, I wanted to grep the include paths in a simple fashion on both OSX/Linux:

macOS:

```bash
$ /usr/local/opt/llvm/bin/clang++ -Wp,-v -x c++ - -fsyntax-only < /dev/null 2>&1 | grep -e /clang
/usr/local/Cellar/llvm/6.0.1/lib/clang/6.0.1/include
```

Linux:

```bash
$ clang++ -Wp,-v -x c++ - -fsyntax-only < /dev/null 2>&1 | grep -e /clang
/usr/local/lib/clang/6.0.0/include
```
