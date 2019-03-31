---
title: 'Eclipse + SSH'
date: 2014-02-08T10:11:00.002+01:00
draft: false
tags : [ssh, Remote System Explorer, Eclipse]
authors: [mathias]
categories: [notes]
---

I work a lot across multiple systems of various OS'es and configurations, and usually I do it via ssh. However, almost everytime, the tasks get much slower than they ought to be, due to the fact that the remote system doesn't have your local tools and configs.

Since I mostly use Eclipse on my local system, and since it's plugin based, I thought of searching for such plugins, and imagine my surprise that it actually exists!

It's built in, and it's called [Remote System Explorer](http://help.eclipse.org/helios/index.jsp?topic=%2Forg.eclipse.rse.doc.user%2Fgettingstarted%2Fg_start.html).


I use the Kepler version, and didn't have to install RSE, it already existed. (According to the link, you can install it from Eclipse 3.4)

All _I_ had to do was add a "perspective" in the top right corner (default place)

[![](http://2.bp.blogspot.com/-xhkT2tM1Hio/UvXye_0hoqI/AAAAAAAAA8o/xPYCiQS-icA/s1600/Screen+Shot+2014-02-08+at+09.57.40.png)](http://2.bp.blogspot.com/-xhkT2tM1Hio/UvXye_0hoqI/AAAAAAAAA8o/xPYCiQS-icA/s1600/Screen+Shot+2014-02-08+at+09.57.40.png)


Click the plus

[![](http://2.bp.blogspot.com/-mPicV-ILeJM/UvXyiDwsToI/AAAAAAAAA80/s54H2NJyS-I/s1600/Screen+Shot+2014-02-08+at+09.59.39.png)](http://2.bp.blogspot.com/-mPicV-ILeJM/UvXyiDwsToI/AAAAAAAAA80/s54H2NJyS-I/s1600/Screen+Shot+2014-02-08+at+09.59.39.png)


Choose "Remote System Explorer" and press ok.

[![](http://4.bp.blogspot.com/-1Nosidao7TQ/UvXyiBQw1TI/AAAAAAAAA8w/1T9iENRX3pA/s1600/Screen+Shot+2014-02-08+at+10.00.28.png)](http://4.bp.blogspot.com/-1Nosidao7TQ/UvXyiBQw1TI/AAAAAAAAA8w/1T9iENRX3pA/s1600/Screen+Shot+2014-02-08+at+10.00.28.png)


Click the little plus sign ("Define a new connection")

[![](http://1.bp.blogspot.com/-qtUoU0-IWsA/UvX0Nms3CfI/AAAAAAAAA9E/HcuZwfS2_Qs/s1600/Screen+Shot+2014-02-08+at+10.08.37.png)](http://1.bp.blogspot.com/-qtUoU0-IWsA/UvX0Nms3CfI/AAAAAAAAA9E/HcuZwfS2_Qs/s1600/Screen+Shot+2014-02-08+at+10.08.37.png)

From there, I added a new ssh connection. I think you can take it from here :)

Enjoy!