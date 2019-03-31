---
title: 'Sublime Text 3 custom build'
date: 2017-05-28T16:22:00.000+02:00
draft: false
authors: [mathias]
tags: [IDE, Sublime Text]
categories: [notes]
---

Adding a custom build step to Sublime Text 3 is easy.

Simply choose

    "Tools -> Build System -> New Build System"

and it will create a new .sublime-build file that you can configure to your liking.

How to configure it, can be found in the [Configuration manual](http://docs.sublimetext.info/en/latest/reference/build_systems/configuration.html#build-systems-configuration).

In my case, I wanted to invoke the build.sh file in the project root directory:

    // The initial version

    {    "cmd": ["sh", "build.sh"],    "working_dir": "${project_path:${folder}}"}

## Build output

[![](https://1.bp.blogspot.com/-qXpsjGCpfVc/WSrc0luaFeI/AAAAAAAAC30/-wKt33Nbnzc5dtDHeNpmgmzx-CVZxbCpQCLcB/s320/Screen%2BShot%2B2017-05-28%2Bat%2B16.20.19.png)](https://1.bp.blogspot.com/-qXpsjGCpfVc/WSrc0luaFeI/AAAAAAAAC30/-wKt33Nbnzc5dtDHeNpmgmzx-CVZxbCpQCLcB/s1600/Screen%2BShot%2B2017-05-28%2Bat%2B16.20.19.png)

The final output


Next, I needed to capture the output from the compiler, and in this case, it's from the arduino compilers. Unfortunately, the ansi output they produce couldn't be handled by either Sublime Text 3 or the plugin [ANSIescape](https://github.com/aziz/SublimeANSI). The only solution I managed to conjure up was to install ansifilter and use that.

    $ brew install ansifilter


And, since the "cmd" tag doesn't support more than one command, and because "shell\_cmd" doesn't support "working\_dir", I ended up with this:

    // Final version{    "shell_cmd": "cd ${project_path:${folder}} && ./build.sh 2>&1 | ansifilter",    "file_regex": "^(..[^:]*):([0-9]+):?([0-9]+)?:? (.*)$",    "syntax": "Packages/Makefile/Make Output.sublime-syntax"}

Note that when using the "shell_cmd", it create a shell for each build. So if you do something time consuming things in your bash startup scripts, it will take extra long time to build in Sublime as well.



You can read more on the subject [here](https://addyosmani.com/blog/custom-sublime-text-build-systems-for-popular-tools-and-languages/)