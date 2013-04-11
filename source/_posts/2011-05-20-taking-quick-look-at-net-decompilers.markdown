---
layout: post
title: "Taking a Quick Look at .NET Decompilers"
date: 2011-05-20
comments: false
categories:
 - coding
 - software tools
---
Decompilers in the .NET space has changed a lot since the announcement from Red Gate that they were going to start charging for Reflector, which was the defacto most important/useful tool in any developer's tool belt.

This blog post will be a quick overview to take a look at all the new contenders that have cropped up in the .NET space to see if any of them can dethrone Reflector as the decompiler of choice.  This is only taking a look at the tools as a stand alone product and excludes any IDE integration.

To start, let's take a look at Reflector.

# [Red Gate Reflector](http://www.reflector.net/) (7.1.0.143)

Having been around for years, Reflector is a rock solid product that sets the standard for everything else.  It has a simple straight forward interface and has a large following with many 3rd party addins.  It has a search which lets you find types, and an analyzer which shows you incoming and outgoing calls for any method.  It also has the most options for decompiling, giving choices from C# to VB and even Delphi.

Another useful feature is being able change the framework from .NET to WPF to Silverlight.

As of this version it looks like they added tabs, but it for me it only used one at a time…perhaps a limitation of the trial version.

# [ILSpy](http://wiki.sharpdevelop.net/ilspy.ashx) (1.0.0.822)

This open source offering at this point looks the same as Reflector did just before Red Gate took over.  It has all the necessities, including search and analyze.  It can only view one thing at a time, and doesn't have support for addins yet.  However, progress on this project is blazing fast and it's only a matter of time before it reaches feature parity with the rest.

# [JustDecompile Beta](http://www.telerik.com/products/decompiling.aspx) (2011.1.516.2)

First impression was, damn, this is a nice pretty WPF app.  Onwards, it has a predefined assembly list of .NET2, 4, and Silverlight, which is nice.  What's nicer is that you can save a predefined list for use later, a feature that's absent from the others.  It has search by type, and search by symbol, however, the search is noticeably slower than everything else I tried.  Also, the actual decompiling is much slower than the rest as well.  Like ILSpy, it can only view one thing at a time.

Decompiling to C# and VB are supported, but no IL yet.

# [dotPeek EAP](http://www.jetbrains.com/decompiler/) (1.0.0.1219)

I tried an EAP build and I was blown away.  I may be biased because I'm a Resharper user, but having almost all of the keyboard shortcuts I have in my muscle memory work in dotPeek was a welcome surprise.  The keyboard navigation makes dotPeek *by far* the best tool for navigating.  While the others have searches, they only do so at the type level.  With dotPeek (just like Resharper), you can search by type, current type, and even private members.  Inheritance searching like finding implementations, etc., all of that works.  Simply amazing.  Oh, and it also has full tab support.

It was also fast as well, which was a surprise considering it's searching through the entire framework.  Searching all symbols for `m_` brought a list up in 2 seconds, and subsequent keystrokes narrowing it down occurred within half a second.

The downside?  No support for decompiling to IL, and lambdas aren't fully supported yet.  I'm sure these will be done by the time it's released.

# Conclusion

I guess the most important thing I should be looking at is the actual decompiler, rather than the bells and whistles. If that's what I looked at, this would be a pretty boring post because only Reflector is able to decompile everything out there.

JustDecompile failed to decompile some of the assemblies I threw it at it.  dotPeek at this stage doesn't have good lambda support (if at all).  ILSpy decompiles very well at this point and I'd have to go out of my way to find an example where Reflector does it better than ILSpy.

In conclusion, I love dotPeek just because of the awesomeness that is Resharper keyboard shortcuts.  For everything else, ILSpy does the job.

I'm actually pretty thankful that Red Gate decided to charge money for Reflector, because that inspired so much competition and we already have 3 viable replacements, all of which are free -- something that wouldn't have happened if Reflector remained free.
