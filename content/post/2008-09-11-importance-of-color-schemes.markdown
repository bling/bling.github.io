---
layout: post
title: "The Importance of Color Schemes"
slug: importance-of-color-schemes
date: 2008-09-11
comments: false
---
It is surprising to me how few people use custom color schemes and just stick with the IDE defaults.  I'm not saying that the ones shipped with Visual Studio are bad, quite the contrary.  They are good, but it can be better.

Since VS2005, we've been given the option of having different colors for classes, value types, delegates, enumerations, and interfaces.  I consider this to be one of the single most useful features in the IDE.

Let's take a look at the following comparison:

![comparison](http://i34.tinypic.com/t8uky1.png)

The first thing you'll probably notice is that I program on a black background.  I find this to be easier on the eyes.  It takes some getting used to at first, but once you go black you don't go back :-)

These are the colors I use (or slight variations) and it helps me tremendously in keeping track of what's what.  It also prevents the need to use any ugly prefixes for any variable names.  Another reason I use a black background is that it's much easier to tell the difference between different shades of colors on a black background than it is on a white background.

Anyways, it should be clear that my custom color scheme provides *much* more information than the default color scheme.  At an immediate glance of the code you know exactly what is a delegate and what is a class.  There is no dependence on the name or anything else.  And since we can read colors faster than we can read words, this will increase your productivity.

The most important one, in my opinion, is the one that differentiates reference types from value types.  C# lets you declare instances on the heap or on the stack, although they have the same syntax.  The compiler is smart enough to tell the difference though, so you should take advantage of that and have the colors different.
