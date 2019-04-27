---
title: "Arduino + HomeBridge"
date: 2019-03-31T00:00:00+01:00
tags: ['arduino']
draft: true
categories: ['notes']
authors: ['mathias']
---


https://github.com/nfarina/homebridge/wiki/Install-Homebridge-on-macOS

    $ brew install npm
    $ sudo npm -g install homebridge


Since I got an error: `"Error: Cannot find module '../build/Release/dns_sd_bindings'"`

    $ sudo npm install --unsafe-perm mdns
    $ cd /usr/local/lib/node_modules/homebridge/node_modules/
    $ sudo npm rebuild --unsafe-perm

