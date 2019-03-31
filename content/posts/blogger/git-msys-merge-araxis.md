---
title: 'git (msys) + merge + araxis'
date: 2013-01-28T12:09:00.000+01:00
draft: false
tags : [araxis, git]
authors: [mathias]
categories: [notes]
---

I struggled with setting up the git environment in my windows environment.
And since it's easy to forget these things, I'll just add the command lines for it here:

```bash
$ git config --global merge.tool araxis git config --global mergetool.araxis.path 'C:\Program Files (x86)\Araxis\Araxis Merge\Compare.exe' git config --global diff.tool araxis git config --global difftool.araxis.path 'C:\Program Files (x86)\Araxis\Araxis Merge\Compare.exe'
```