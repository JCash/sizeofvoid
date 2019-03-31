---
title: 'xxHash64 - a fast 64 bit hash function'
date: 2014-07-16T16:43:00.000+02:00
draft: false
tags : [C++, hash, xxHash64]
authors: [mathias]
categories: [notes]
---

In my work I often use various hash functions as hashes or checksums, and it's always beneficial to know about different qualities and speed of the functions available.

[Yann Collet](http://fastcompression.blogspot.se/) (known for the LZ4 compression algorithm) has now updated his xxHash algorithm with a 64 bit version, and it's speed is quite excellent. On my machine, a 64bit MBP @ 3GHz:

    xxHash64            - ~13.5 GB/s
    CityHash128         - ~12.5 GB/s
    CityHash64          - ~11.5 GB/s
    MurmurHash3_x64_128 - ~5.5 GB/s

The function has been tested against the [smhasher](https://code.google.com/p/smhasher/) suite, and passing all tests. Although the tests are more geared towards 32 bit hashes, the well known MurmurHash3 function is also tested against this suite.

The XXH64 is implemented mainly for 64 bit platforms, so it's performance is not as good on 32 bit systems. But then you probably would use XXH32 anyways.

I'm sure more tests will reveal more of the hash quality in the future.

For code and speed comparisons, check it out at [https://github.com/Cyan4973/xxHash](https://github.com/Cyan4973/xxHash)