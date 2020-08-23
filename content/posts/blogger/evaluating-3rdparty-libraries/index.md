---
title: 'Evaluating 3rd party libraries'
date: 2020-08-23T00:00:00.002+01:00
tags : [C, C++, Software]
authors: [mathias]
categories: [programming]
---

After starting a thread on [twitter](https://twitter.com/mwesterdahl76/status/1296100741011185665), I decided to write up the points in a slightly more structured manner.

The end goal is to get a list of candidates, complete with relevant into that your team can make a decision upon.

It is an iterative process: after each step, I add more info. And I keep the list ordered.

## The first list

The first step is to find as many available options as possible, and create a first list
of the features and potential pros and cons.

What you look for here is dependent on what you value in a library.
The idea is to make this list quickly, so that you'll know what libraries to focus on in the next steps.

### Functionality
It's perhaps obvious, but the code should do what it's intended to do.
It might lack some features. And it might contain features you don't want/need.
Can those features be easily removed from the final build?

### Code Size
Is the number of files reasonable for the functionality they provide?
Less code is (usually!) more maintainable.
Additionally, it will most likely both compile and run faster.

And, for mobile/web games, download size is still very important.
Often there's a 1-5mb game size requirement.

### License
Using a license that fits well with your project.

### Is it commercial?
What's the price? Is it per year/product or what?
Does it come with support? What does the support cost?
Can I get a trial version to test with?

### Code Updates
Is the code repo "alive"?
Is it receiving regular updates?
Does it have many users?
A good exception from this rule is LuaJIT 2.1 beta, which has been in beta state for a couple of years now.

### Dependencies
Are there any code dependencies or technologies that you should know about?
E.g the use of other 3rdparty libraries, or very "modern C++" constructs that prohibit you from using it.

### C++ ABI
If the code uses `<string>`, and `<iostream>` etc, it might very well clash with other precompiled libraries that
you want to use. I usually stay clear of such libraries.

### Bugs
Are there many unattended issues in the repo?
Or perhaps there are no issues at all?
Is there any paid support available?
Is the repo accepting pull requests?

{{< figure src="list01.png" height="25" title="Here's what a first take on a list might look like" >}}

## The second look

After sorting the candidate list, it's time to look deeper at the code.

### Memory management

How does the library manage memory?
Preferably, I'd like to do the allocations on the application side, as opposed to internally in the library.
Does it allocate memory upfront, or does it do many small allocations at runtime.

### Threading

Is the library thread safe, or is it possible to manage yourself?

### Api

Are you satisfied with the way the api works?
Is it easy to configure?

## The first tests

Once I feel confident about the current ordering of the list, I can start touching the code a bit.

### Test compilation

Going through
Almost all repos come with a predefined build system.
My first try is to compile the library and its examples. Having access to working examples usually help.

This step fails surprisingly often, even for popular libraries, using popular build systems like `make`/`CMake`.
And it _does_ factor into my overall assessment of the library.

### Cross platform

Does the code look to be easy to compile for all platforms/architectures?
If the repo is using large Makefiles or CMake, is usually a sign that the library is more complex than I'd like.
It is often quite hard to make 3rdparty libraries compile for all supported platforms.

### App test

If feasible, I also try to do a quick test in the app itself.
E.g. when replacing an existing library with this new library.

## Can I write it myself?

As you look through the list of candidates and their code, you will probably get a grasp of how feasible it would be for your team to write the library yourself.

Don't think of it as "reinventing the wheel", you'll create a library that suits your specific requirements.

## Review

Once you feel content with the info provided in the list, it's time to do a review with the team. They might come up with new questions that need answering. It's an iterative process.

## Summary

These are the steps I usually go through when finding a new library, and it has worked well over the years.

If you have another way of doing it, or other questions you ask during the evaluation, please share with us!









