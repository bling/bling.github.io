---
layout: post
title: "Fixing ReSharper 5 EAP Missing Colors"
date: 2009-11-07
comments: false
tags:
- visual studio
---
I think anyone’s who has used ReSharper for an extended period of time has experienced the colors disappearing all of a sudden from Fonts & Colors.  This is excruciatingly annoying when I have a dark color scheme set up and the colors disappear on me.

In the case of RS5, it seems even more flakey than RS4, and installing/uninstalling other addins have a pretty high probability of losing the colors, and this time, repairing the installation doesn’t fix the problem (nor does the registry restore trick).

For me, to fix the problem I had to:

- Uninstall RS5.
- Install RS4.5
- Open VS!!!
- Go into settings, and verify all the colors are in Fonts & Colors.
- Upgrade to RS5.

If you skip opening VS, it will not restore colors...at least it didn’t when I tried it.  Following the above fixed it for me in 2 occasions already.  If Jetbrains sees this blog post, PLEASE fix this extremely annoying bug.
