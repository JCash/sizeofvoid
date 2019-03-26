---
title: 'Language speed tests'
date: 2013-11-10T12:42:00.003+01:00
draft: false
tags : [C++, Python, C#, Google Charts]
authors: [mathias]
---

## The beginning

Even though there are many language tests out there on the internet, I wanted to have a go at it myself, to find out the cases _I_ wanted to know about and to have control over the test. Also, I wanted to do it because I thought it might be fun to write a little testing framework and reporting tools! (And it would make some nice weekend programming)

But even though this might be a bit whimsical, one real question I've had for some time is "how fast/slow is Python compared to C#" (Or C++ even) ? So I went ahead and tested the languages I come across most often: C++, Python & C#.

If you want to skip to the results, here they are:

[http://jcash.github.io/languagetests/](http://jcash.github.io/languagetests/)

And here is the code:

[https://github.com/JCash/languagetests](https://github.com/JCash/languagetests)


## The info

Since I'm using OSX (10.9), I had to go for the mono implementation of C#.

The computer is a Macbook Pro, dual core i7 2.9GHz with 8GB ddr3 ram.

The languages tested are C++11 with Apple's clang LLVM 5.0 (based on LLVM 3.3svn), Python 2.7.5, Python 3.3.2 and Mono 3.2.3.

The implementations of the tests are not optimized, but rather written in a "common" way, that any person might choose if they were writing the function. For instance, I know C++ programmers tend to write C++ style in Python when they first migrate.

Also, there is something to be said for C++ and its lack of a built in big integer support, which Python and C# has. I ended up using GMP, which seemed like a good choice performance wise. However, note the interesting results in the fibonacci tests. The C++ code is comparable to Python, and they both get beaten by C#

In the recursive Fibonacci test, I couldn't go further than N=20, since after that point, Python started to take insane amounts of time.

I generate html code in the report, and use [Google Charts](https://developers.google.com/chart/) for presenting the graphs.

## The Results

Well, I haven't really concluded much other than that you should (as always) know your code, your language and the tools (built in or 3rdparty) you use.

And, I really need more tests of every day scenarios to draw more conclusions.

The results are posted here: [http://jcash.github.io/languagetests/](http://jcash.github.io/languagetests/)
That said, i'll make some (very broad) conclusions:

### Python

*   Python 3, in some scenarios, performs up to 100% faster than Python 2
*   Avoid too wildy recursive functions, like in the Fibonacci recursive test.
*   Python is in some cases faster than C# and C++

### C++

*   GMP, in some scenarions, performs worse than the builtin big integer classes in C# and Python.

## The end

I hope to add some more tests of course, including optimized versions for comparison.

And I also intend to run the tests on Windows/Linux.
If there's anything in particular you wish to see tested, drop a comment!