---
title: 'Install SSH server on Windows 7'
date: 2014-07-18T18:18:00.002+02:00
draft: false
tags : [ssh, Parallels Desktop, Bitwise, VM]
authors: [mathias]
---

Since I don't want to maintain several Parallels Desktop VM's on each of my machines (due to disc space and maintenance), I need to be able to ssh into them, but also use the same shared folder where I have my code.

## Bitwise SSH Server

When googling for windows ssh servers, the majority of the answers were pretty old, but I didn't really mind that as long as they worked ok. I tried installing OpenSSH via cygwin (which was easy), but that gave me a cygwin prompt which didn't have all my user's environment variables and it also behaved erratically (and occasionally hung). I also looked into using the freeSSHD, and that had a nice UI to change settings and add users. But it just never let me log on (Access Denied), despite trying all the tricks google gave me.

In the end I limited my searches for the latest year, and at the top it suggested the [Bitwise SSH Server](http://www.bitvise.com/ssh-server). It's free for personal & non commercial use and it was really easy to setup. Run the installer, and then add a user in the UI settings. Et voila! Everything worked out of the box!


## Shared Network Folders

The setup I have is that I have my code on my MBP, the Windows VM on an iMac. So I want to login in to the VM, and there I want to compile my code using MSVS.

Parallels Desktop is good at sharing Mac & Samba folders with the VM, but my problem is still with the ssh login: It cannot access the mapped drives!

If I run `$\> net use` the drives are there, but I can't cd into them! They're listed as "Network: Parallels Desktop Folders" and their "status" fields are empty.

However, when I run `$\> net use L: \\\10.0.1.42\\shared /user:MACBOOKPRO-AB12\\mawe` the drive mounts nicely (after password confirmation). And fortunately, the [Bitwise ssh server remembers mapped shares](http://www.bitvise.com/ssh-server-accessing-file-shares) by default (if they're mapped as Microsoft Windows Network) so the next time you log in, the drive is still there.

## Yay!

I've heard about the SSH server issues on Windows before, but with such a great tool, I definitely think those days are gone. I am now a happy multi platform coder again!