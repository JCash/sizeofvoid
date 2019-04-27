---
title: "Dungeon Generator: Rooms and mazes"
date: 2019-03-31T00:00:00+01:00
tags: [dungeon, maze]
draft: true
categories: [programming]
authors: [mathias]
---

I've always liked games with dungeon, but I never actually created one myself. So I thought that it was time to start playing around with idea. If you search on the net, you'll find plenty of variations of dungeon generators (some with online examples). One article I found was pretty straightforward, and I thought it'd make a good starting point: Rooms and Mazes

Here's the initial result:

![example.png](/images/dungeon-generator-1/example.png)

But the the implementation has a few issues I'd like to iron out:

* Remove iterative placement of rooms (it's based on trial and error)
* Make room placement look more "man made"
* Make mazes more believable (e.g. more straight)


## Room placement

In choosing an algorithm, it's good to acknowledge the fact that the dungeon is indoors. It's either a cave system, or a set of rooms inside a mansion/castle.

Since the layout in those scenarios is vastly different, it is only fair to use different algorithms to achieve the different results.

## BSP Placement

Using a BSP approach, helps in making sure to distribute the rooms over the entire area, thus making it easier to achieve the desired number of rooms. The "blockiness" this approach gives, can of course be a down side, but also gives the feel of a man made structure.

![example.png](/images/dungeon-generator-1/example_bsp.png)

