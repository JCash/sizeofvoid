---
title: 'OSX + Parallels Desktop + Windows keyboard'
date: 2015-09-28T11:33:00.002+02:00
draft: false
tags : [OSX, Parallels Desktop, Keyboard, windows, Key Mapping]
authors: [mathias]
---

I just bought a Windows keyboard to help with my coding(and gaming) but as you can imagine, not everything went without a hitch. In particular, I had troubles with the Command and Option keys due to my muscle memory of working with a mac for so long :)

Using the OSX default keymapper simply didn't work, since there you could only map Command (both) to Option and vice versa. And if you did that, the AltGr inside Parallels Desktoip Windows stopped working (and although you could map them back in Parallels Desktop, it was the same issue there, you mapped both left and right keys as one!)

The solution was to use [Karabiner](https://pqrs.org/osx/karabiner/), formerly known as KeyRemap4MacBook. In there you could distinguish between left and right keys!

So I mapped Command Left to Options Left and vice versa, but now I had the issue of it not working in the Windows VM. Then I installed [SharpKeys](http://sharpkeys.codeplex.com/), which could do the same, map the keys back!

So now I have a working setup for both OS'es, and if I find a new issue, I'm pretty confident these two programs can solve that.