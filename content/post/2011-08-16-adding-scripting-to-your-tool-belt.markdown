---
layout: post
title: "Adding Scripting to your Tool Belt"
date: 2011-08-16
comments: false
---
One of the most important things for any developer is to be well rounded.  They should know about functional, imperative, object-oriented, aspect-oriented programming, among others.  They should know the difference between dynamic and static languages.  They should know the difference between scripting, interpreted, compiled languages.

Why?  It opens your mindset.  It lets you see things in a different light, which ultimately changes the way you will write your code, and for the better.

The best example is when C# introduced lambdas and LINQ.  All of a sudden, the masses saw the benefits of functional programming style and how it *greatly* makes code succinct.

Here, I give an example of what knowing a little about Powershell did to save me a lot of time.

I use git-tfs to make my day job a little less painful every day, because I cannot stand TFS, at all.  In their latest release, they decided not to tag every changeset.  I like my things consistent, so I decided to go back in history to untag all the changesets.

Unfortunately, git doesn't have a mass untag, and you must untag each branch individually with `git tag -d name_of_tag`.

This is how you do it with Powershell:
``` powershell
50000..40000 | % { git tag -d "tfs/default/C$_" }
```
50000..40000 creates an list of numbers from 50,000 to 40,000, then it gets piped `|` into a foreach loop `%` to run the git tag command by generating the tag name with the current loop item `$_`.

Why was this awesome?  I didn't have to open up Visual Studio, or a text editor, or anything.  I just typed it into the shell.
