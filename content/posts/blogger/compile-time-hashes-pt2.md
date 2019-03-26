---
title: 'Compile Time Hashes pt2'
date: 2012-08-09T00:05:00.000+02:00
draft: false
tags : [gcc, C++, cl, hashlittle, clang]
authors: [mathias]
---

While waiting for Visual C++ to implement the C++11 features I wrote about in the [previous entry](http://sizeofvoid.blogspot.se/2012/07/compile-time-hashes.html), I wanted a solution that worked on windows. This time I needed to implement the hashlittle function found in [lookup3.c](http://burtleburtle.net/bob/hash/).

I used template programming to get the size of the string at compile time and I also relied on the compilers to optimize the code into the final result.

You can download the final code here: [hashlittle.zip](https://sites.google.com/site/mwesterdahlfiles/home/hashlittle.zip)
Update (2012-08-20): Fixed bug in function for edge cases where the string was a multiple of 12 (doh!)



## Did it work?

This method relies heavily on that the compiler can optimize the code during compile time. You need to make sure that the code you use isn't too heavy for the compiler to optimize.

To verify that it worked, I had to check the generated instructions:

```c
movl  $1468455736, %esi       ## imm = 0x5786DB38
movl  $1468455736, %edx       ## imm = 0x5786DB38
xorb  %al, %al
callq  _printf
```

This output from clang tells me that the hash of my 80 character test string has been converted into a constant. So I consider it a success. I got the same constant with gcc and cl as well.


## Performance

Since the implementation is both templated and recursive, the performance is affected. For shorter strings I don't think it's going to be a big loss. If you are already using some build step to generate the hashed values (e.g. in a header file), this solution might very well be for you.

The hash function can convert very "long" strings (500+ chars) but that will definitely affect your compile time. The table shows the compile time of hashing one string together with a printf.

| Compiler  | GCC 4.7.1    | Clang 3.2    | Visual C++ 11 |
|-----------|-------------:|-------------:|--------------:|
| 10 chars  | 0.149s       | 0.135s       | 0.121s |
| 80 chars  | 0.215s       | 0.357s       | 0.349s |
| 200 chars | 0.357s       | 0.961s       | 3.40s |
| 500 chars | 1.375s       | 6.75s       | 103.3s |

For me, the benefit of avoiding a custom build step outweighs the cost of a slightly slower hash function (for shorter strings that is).


Issues
------

For a while, the compilers refused to optimize the code, even for the shortest strings. Until I realized that I have to use even stronger hints for inlining.

```cpp
#if defined(_WIN32) || defined(_WIN64)
 #define ALWAYSINLINE __forceinline
#else // GCC + CLANG
 #define ALWAYSINLINE inline __attribute__((always_inline))
#endif
```

Also, for some reason unknown to me, clang needed O2 and the others only O1