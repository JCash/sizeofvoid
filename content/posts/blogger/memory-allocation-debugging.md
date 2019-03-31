---
title: 'Memory allocation debugging'
date: 2018-01-21T10:39:00.001+01:00
draft: false
tags : [OSX, C++, debugging, memory]
authors: [mathias]
categories: [programming]
---

Sometimes it's beneficial to see the actual memory allocations done by an app, but you don't want to code a full memory allocation system. Perhaps you cannot even rebuild the app.

Then a good option is to use a dynamic library to override all the allocation functions.

The idea is simple, make sure the application finds your library before any other, and let it use the custom malloc-functions. Here is the [source](https://github.com/JCash/memprofile)

On MacOS, you'll use

```bash
$ DYLD_INSERT_LIBRARIES=libmemprofile.dylib ./a.out
```

and on Linux:

```bash
$ LD_PRELOAD=libmemprofile.so ./a.out
```

The result will look like this:

```bash
$ DYLD_INSERT_LIBRARIES=libmemprofile.dylib ./a.out
Memory used:

 Total:  512 bytes in 2 allocation(s)

At exit:  0 bytes in 0 allocation(s)
```
