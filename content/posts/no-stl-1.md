---
title: "Why I don't use stl"
date: 2019-03-31T00:00:00+01:00
tags: ['c++']
draft: true
categories: ['programming']
description: "Some notes on why I don't use STL anymore"
authors: ['mathias']
---

# Why I don't use STL

## Brief

Every now and then, you see or hear an argument about C++'s STL "Why or why not" using it.

There was a time ten or twelve years ago that I would have said yes to everything STL (and probably boost if that had been around), but nowadays, I will say no to it.


TL;DR: I just don't need it.






Note that I don't want to try to convert everyone, but merely mention why I don't need it.

And perhaps by doing that, convince someone else to try to not use it :)


Also note that I'm specifically talking about the actual game app here, not the tools or tests built to support the app during the development. But even in tools, I anticipate the usage exceeding the initial expectations, pushing memory/perfomance more than


When creating an app, I appreciate these things (among others) about it, both in development and when released.

It should have:


    Fast compile times (in development)
    Small, maintainable code (in development)
    Fast startup time
    Low CPU usage
    Low memory usage



Fast compile/turnaround times

I don't use that many things that exist in STL, a few containers, and some algorithms and a few helper functions, that's it. But, the implementations are very heavy on the template side, and quite generic. This in turn leads to compile times that I don't like.


I've seen the effects of STL and boost on a project, where one app build went from 5 minutes to 20+!

Given 40 coders and 4 years, that's a lot of time lost.


I'm used to compiling a lib and a unit test (and run it) in a couple of seconds, and I wouldn't want to jeopardize that. I can keep the focus on the task!
Maintainable code

The second argument, the maintainable code, is often an argument for using STL. The argument being that you want stable, tested code that you can rely on.


But really, the use cases I've seen in the projects I've worked on, are various (simple) containers,  some algorithm functions and some helper functions, and to be honest, these are not hard to write, or write tests for.


Also, while debugging the STL code, I will likely get very crazy call stacks.

This makes the debugging much more difficult, since I will lose my (mental) context every now and then.


Fast startup time

What I'm after here is the executable size. Not only will a smaller executable load into memory faster, but it's quite likely that it will run faster too.


On a PS2 project I worked on, the executable was 20+ MB, and it would barely fit into memory together with all the game assets. Loading that from disc into memory took some time. A lot of that code was due to STL. Compare that to the game God Of War, where the PS2 executable was 1.5MB (source)


In this case, my problem with STL is that many of these functions and classes are very generic, and will drag with them a big amount of code, making the executable unnecessarily large. std::string is one example.


Low CPU Usage

Most developers I know use a custom hash function in their engine. This is for performance reasons.

So why not use custom implementations for the other stuff, for the same reason?

The argument against it, would perhaps be that you might not gain very much in some cases, but I urge you to test it, I think you can do better in many cases.


Hash tables are another common example, and if you give it ~250-300 lines of code, you can have something that is really fast, and definitely beats the std::map/std::unordered_map.


My coding style is very C-like C++, so for arrays, I use C-arrays if they don't need to grow, or sometimes an Array class if I wish to grow it.

For the occasional linked list, I use a next pointer.


Not having all those safety checks that you might find in the STL containers, is a good win during development too.


For algorithms, I only use sort and lower/upper_bound. When rewriting the lower/upper_bound without the stl constructs, in my case it became 1.6x - 2.3x faster.


The std::sort is the last one to go actually, I didn't think it was that slow, but given an old iPhone 4S, it would amount to quite a bit. I will replace it with a radix sort, since I only sort uint64 render keys.

On the computer it was ~10x faster, and it was ~3x faster on the iPhone 4S.


Of course, profiling your code should always be a first step to actually find the hot spots, but if you know that you have something faster close at hand, why not use it?


Low memory usage

One thing that I don't like with STL is the way it handles memory. Sure there are allocators, but I want my instances of containers to have fixed memory, but the stl allocators are set per class.


Nowadays, STL containers have less overhead than they used to, but it's still a fact that they do a lot of dynamic allocations.



Why should I care?

I can think of two reasons: User experience, and money


The user experience

Smaller executable means smaller download, which is good if you make mobile games. That means that those with a bad connection or expensive data plan can download and play your game.


Smaller executables also start faster, and people won't lose interest in the app as fast.


Developers will get more done if the app starts faster. And get less frustrated.
Money

Compiling the code will take some amount of time (seconds, minutes...), and given your team size and project length, the accumulated time will amount to money, both in lost work time, but also loss in focus (context switching) for the developer.


You might not think of it, it's very easy to add a new header, but the fact is that it will take longer time for everyone. A project I worked on went from 5 minute build time to 20!


A common way to try to minimise this overhead is to use clever build systems, or precompiled headers or... something else.


I would argue that removing one of the root causes is a better approach use of the big STL framework.



Ok, how do I do it?

As it turns out, the STL library is made to be generic, and that leaves us with room for improvement!


Try replacing functionality piece by piece.

First, profile or make an educated guess where


And, there are most likely others that have done this before you, so search the web too for inspiration.

Often enough, the containers are not a one to one replacement, but adapting your code is usually straight forward.



Containers


I guess most people use STL for its containers.

In the games I make, we use:


    Hash table
    Array (if they're dynamic)
    Index pool


Functions / Algorithms


    Hash function (e.g. xxHash)
    Sort
    Lopwer / upper_bound
