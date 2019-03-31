---
title: 'Qt Plugin Cache'
date: 2013-06-08T16:08:00.000+02:00
draft: false
tags : [PySide, sqlite, windows, Qt, environment]
authors: [mathias]
categories: [notes]
---

When upgrading an application to use a newer Qt version (4.8), I stumbled across a weird issue with the sql plugin not loading correctly. Even though I triple checked the paths, it didn't work.

This was surprising since if I used the previous Qt version (4.7), my app worked fine!

After much trouble shooting and testing and googling, it turns out that there is a thing called the "Qt Plugin Cache"!

The problem I had was a result of a few things.

My Qt app is 64 bit and it launches another 32 bit Qt app. This in itself is not a problem, but I was making use of the QT_PLUGIN_PATH environment variable, which then was inherited by the child process.

So, I accidentally enforced 64 bit dll's onto the 32 bit app. Bad idea, I know, but also easily fixed. Right?

The problem is that Qt is using a list of failed plugins in the registry. And since the 32 bit app didn't succeed in loading the 64 bit dll's, they got tagged as "failed". As a result, when the 64 bit app then tried to load the dll itself, it always failed.

The problem itself was easily fixed, the trick was to know how Qt works. and not use QT_PLUGIN_PATH so casually. Also, I had to delete the "Qt Plugin Cache 4.8.false" registry entry (see the link below) and try again.

Hopefully this helps you avoid such trouble in the future.

Want to know more? See [Deploying Plugins](http://qt-project.org/doc/qt-4.8/deployment-plugins.html)

**EDIT:** Removing the registry cache from PySide:

```python
settings = QtCore.QSettings("HKEY_CURRENT_USER\\Software\\Trolltech\\OrganizationDefaults", QtCore.QSettings.NativeFormat) settings.remove("Qt Plugin Cache 4.8.false")
```