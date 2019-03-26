---
title: 'Compacting Virtual Box Drives'
date: 2013-10-09T00:20:00.000+02:00
draft: false
tags: [vm]
authors: [mathias]
---

Too many times I've forgotten the exact commands on how to compact the virtual drives. Especially for windows, where the tool used, used to have a different name of the argument passed to it. Compacting the drive can save you lots of disc space (last time my drive went from 12GB to 5GB), and for a smaller lap top drive, that makes a big difference.

Windows Guest:
Download [SDelete](http://technet.microsoft.com/en-us/sysinternals/bb897443.aspx) from SysInternals and then run

```bash
SDelete.exe z
```

Linux Guest:
Here, we create a file that fills the entire empty space, and then deleting it:

```bash
dd if=/dev/zero of=fillfile bs=1M rm fillfile
```

Host:
Finally, you let VirtualBox compact the drive
```bash
VBoxManage modifyhd harddrivename.vdi --compact
```

That's it really! I hope I'll remember it a little better this time.

Further info:

* [Use “sdelete -z” when Shrinking a Windows Guest’s Virtual Hard Drive](http://beckustech.wordpress.com/2012/12/26/use-sdelete-z-when-shrinking-a-windows-guests-virtual-hard-drive/)
* [How to Compact a VirtualBox Ubuntu Guest’s VDI file](http://blog.markloiseau.com/2010/10/how-to-compact-a-virtualbox-ubuntu-guests-vdi-file/)