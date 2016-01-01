---
layout: post
title: "GC.Collect Is Bad For You"
date: 2008-09-11
comments: false
slug: gccollect-is-bad-for-you
tags: [ 'coding' ]
---
Sometimes I wish Microsoft didn't include this method in the API because it promotes bad programming.  I've seen people use this in their code and 99.99% of the time, it is incorrect to do so.

I came across a program which had many try/catch/finally blocks which had GC.Collect() in the finally block.  C# has a garbage collector so you, the programmer, does not have to worry about cleaning up memory.  In fact, it's optimized in such a way that it only collects memory when it needs to.  By manually calling GC.Collect(), you are preventing the JIT from doing its job properly.

Not only that, GC.Collect() is *expensive* operation.  It searches every reference in memory to see if there are other objects pointing to them, and if there are no references, it cleans up and removes it from memory.  Something this heavy should definitely not be called without a good reason.

Summary, do not call GC.Collect().  If you want to manage memory, use another language.
