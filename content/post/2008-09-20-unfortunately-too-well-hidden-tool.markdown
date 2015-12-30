---
layout: post
title: "An Unfortunately Too Well Hidden Tool"
date: 2008-09-20
comments: true
---
Alright, maybe it's not THAT well hidden, but it's well hidden enough that most developers don't even know it exists, yet I find it to be probably one of the top 3 tools of Visual Studio that I find most useful.

What is it?  Break into debugger at any uncaught exception.

Yep!  There's actually a feature that can do that!  You don't have to pull your hair out trying to figure out what exception is causing your program to mess up or when it gets swallowed.  You can find the option under Debug -> Exceptions.

This also brings into the discussion about what the purpose of exceptions are.  I'm from the school of thought that exceptions are...well...exceptions.  Exceptions should occur rarely, not regularly, otherwise they shouldn't be called exceptions.  I dread finding code that uses exceptions to break out of methods/functions.  If you program like that you'll probably be quickly annoyed by turning on the feature above because it'll break into the debugger a lot.  While there's always a time where it can be justified, the mass majority of the time it's a bad idea to use exceptions to control program flow.
