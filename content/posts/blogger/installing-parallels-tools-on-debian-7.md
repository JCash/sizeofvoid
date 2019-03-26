---
title: 'Installing Parallels Tools on Debian 7'
date: 2014-02-15T14:52:00.002+01:00
draft: false
authors: [mathias]
---

_This entry is about remembering how I solved this issue (as well as boost some traffix for the blogger that solved it)_

Parallels Tools is a package designed to make various host/guest tools work: Clipboard, shared folders etc.

For some reason though, the Parallels' way of installing it fails. And it turns out to be a mount + security problem.

First off, the iso wouldn't mount when choosing the "Virtual Machine -> Install Parallels Tools". So I had to manually find it using the "Devices -> Cd/Dvd -> Connect Image..." and browsing to **"/Applications/Parallels\ Desktop.app/Contents/Resources/Tools/prl-tools-lin.iso"**

But, it still wouldn't work. So, after some googling I followed this guide: [Install Parallels Tools on a Debian Virtual Machine](http://www.brianlinkletter.com/install-parallels-tools-on-a-debian-virtual-machine/)

In short these commands (on the guest) solved the issue once I got the iso mounted:

```bash
$ umount /media/cdrom
$ sudo mount -o exec /media/cdrom
$ cd /media/cdrom
$ sudo ./install
```
