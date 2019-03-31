---
title: 'binpacking + fonts'
date: 2013-01-05T01:10:00.001+01:00
draft: false
tags : [bin pack, C++]
categories: [programming]
authors: [mathias]
---

[![](https://sites.google.com/site/mwesterdahlfiles/home/binpack_skyline_bl.png)](https://sites.google.com/site/mwesterdahlfiles/home/binpack_skyline_bl.png)
*Skyline-BL (Bottom Left) with
rects sorted on height. Rotation of
the rects were not enabled.*

During the holidays, I've been working with my hobby project of generating bitmap fonts. One of the issues I hadn't looked into yet was the problem of wasted space between the glyphs and rows. And while I still wasn't actively looking to solve that problem just yet, I stumbled upon a good read by Jukka Jylänki - ["A thousand ways to pack the bin - A practical approach to two-dimensional rectangle bin packing"](http://clb.demon.fi/files/RectangleBinPack.pdf) from 2010.

It was a nice explanation of the most common bin packing algorithms and it also came with public domain [source code](http://clb.demon.fi/files/RectangleBinPack/RectangleBinPack.zip) (Thanks Jukka!)






Using the code was easy and I was up and running with it within a few hours. Reading the paper first, I anticipated the Maxrects ans Skyline methods to achieve the best results so those were the ones I implemented.

One thing that is worth mentioning, is that the packing algorithms allow for the rectangles to be rotated, so if you don't want that, you have to comment out a little bit of code (which is a very fast fix).

Here is a comparison of a few of them:


Maxrects-CP:
[![](https://sites.google.com/site/mwesterdahlfiles/home/binpack_maxrects_cp.png)](https://sites.google.com/site/mwesterdahlfiles/home/binpack_maxrects_cp.png)

Maxrects-BAF:
[![](https://sites.google.com/site/mwesterdahlfiles/home/binpack_maxrects_baf.png)](https://sites.google.com/site/mwesterdahlfiles/home/binpack_maxrects_baf.png)

Maxrects-BSSF:
[![](https://sites.google.com/site/mwesterdahlfiles/home/binpack_maxrects_bssf.png)](https://sites.google.com/site/mwesterdahlfiles/home/binpack_maxrects_bssf.png)

Skyline-BL:
[![](https://sites.google.com/site/mwesterdahlfiles/home/binpack_skyline_bl.png)](https://sites.google.com/site/mwesterdahlfiles/home/binpack_skyline_bl.png)

## Conclusion

For my special case of creating fonts, I benefit from debugging the visual quality of the glyphs, so I don't allow the glyphs to be rotated 90 degrees. Also, sorting the glyphs with respect of the height gave the best packing and also increased the performance of the packing (~2x faster than the other methods). So for me, the Skyline-BL gave the best results. But you should of course test your own scenario to see what fits best.

[![](https://sites.google.com/site/mwesterdahlfiles/home/03_layers_effects.png)](https://sites.google.com/site/mwesterdahlfiles/home/03_layers_effects.png)

A pretty good packing as a result.
Debug backgrounds are turned on
to make it easier to debug.