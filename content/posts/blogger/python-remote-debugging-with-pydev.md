---
title: 'Python remote debugging with PyDev'
date: 2012-01-30T15:16:00.000+01:00
draft: false
tags : [Python, debugging, Eclipse, PyDev]
---

Sometimes you wonder why you didn't do something a lot sooner. Like googling for "python remote debugging". I've been a python addict for ca 2 years now and we use a lot of python tools at my work, and being able to remotely debug the tool chain would have saved me/us tons of work.  
  
[PyDev](http://pydev.org/) is a set of tools developed by Appcelerator and is available as an Eclipse plugin. It supports syntax highlighting, code completion, etc. And also remote debugging!  

The [MANUAL](http://pydev.org/manual_adv_remote_debugger.html) is a little sparse and involves code manipulation, which is something I'd really like to avoid. I tried it out though but couldn't really get that to work the way I'd like.  
  
Calling "pydevd.settrace()" will set a hard break point, which might be very useful. But it's very intrusive in the code. Calling "pydevd.settrace(suspend=False)" only connects to the debugger, but is equally intrusive.  
  
Also, how would I go about catching exceptions "C style", when they actually occur?  
You cannot use "sys.settrace()" since pydevd.py is using that. And writing your own sys.excepthook in a module (for use with -m) works, but is a little too roundabout for me.  
  
The optimal solution would be to use the "-m" flag of python with pydev directly.  
  
The Gist of it  
The -m flag works!  


```bash
> python -m pydevd --port 5678 --client 127.0.0.1 --file foo.py
```
  
This will connect to the python debugger (if it's running) and then execute the foo.py script.  
If you have set break points in the foo.py, these will be active!  
  
What about the exceptions then?  
Well, since PyDev 2.2, the "Manage Exceptions Breakpoint" dialog is available via the PyDev gui.  
  
In Eclipse:
[![](http://pydev.org/images/index/manage_exceptions.png)](http://pydev.org/images/index/manage_exceptions.png)
  
If you select "suspend on uncaught exceptions" and select the Exception in the list, you'll get automatic breakpoints when an uncaught exception occur, complete with full stack trace from where the exception originated!  
  
Well, that's really all of what I had to say. It works, and I'm a happy coder.  
  
I suggest that you play around with the PyDev options available in the gui to really make the most of it!  
  
Caveats  

*   Trying to connect to a server that doesn't exist will stall forever, that's how the pydev.py is implemented.
*   As stated in the Important Notes, you might have to modify the path mappings if you want to use breakpoints between separate machines.
*   Python is a very try/except based language, and when using "suspend on caught exceptions", you might get overwhelmed. Then the dictionary pydevd.DONT_TRACE comes into play:

```python
pydevd.DONT_TRACE['myfile.py'] = 1 # will ignore that file during tracing.  
```
  
I hope this helps you!