---
layout: post
title: "SnoopShell: Evolution"
date: 2012-07-29
comments: true
categories:
 - coding
 - software tools
 - powershell
---
It’s been a while since I last announced [SnoopShell](http://blingcode.blogspot.com/2012/07/snoopshell-marriage-of-snoop-wpf-and.html), where I took some PowerShell and injected that into Snoop.  Well, I didn’t stop there!  I decided to continue working on it and adding more useful features.

Well, a bunch of things have changed.  For one, it’s no longer targeted at .NET 4 and PS v3 anymore (and you’ll soon know why).  Second, there’s a bunch of new features!

# Automatic Profile Loading

Upon startup, the shell will look for a couple well known locations and automatically dot-source them to load them into the current session.  This works the same as the standard $profile.  The filename needs to be `SnoopProfile.ps1`, and the search paths are `%USERPROFILE%,` the `WindowsPowerShell`, and the `Scripts` folder deployed with Snoop.exe.

This is incredibly useful since you can write your own custom functions and scripts and have them available to you all the time.  As an added bonus, because of the dynamic nature of PowerShell, you can make modifications to the `SnoopProfile.ps1,` save, and then invoke a `. $profile` to reload the profile and update the session with your changes (all without restarting the application).

That’s awesome sauce indeed ;-)

# PowerShell Provider

This was more of a for-fun thing at first just to see if I could do it.  Writing a PS provider is not fun at all, since it’s not very well documented and I actually needed some help from ILSpy to figure out how things really worked.  Nonetheless, it’s got some basic functionality that is helpful to navigate around.

<a href="http://lh6.ggpht.com/-hpRCncySB3g/UBXOagD2xII/AAAAAAAAALs/qBCKmxV-B0M/s1600-h/image%25255B10%25255D.png"><img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lh6.ggpht.com/-QMqNxt2DmZ8/UBXOa1SVqwI/AAAAAAAAAL0/ULMweSOFso0/image_thumb%25255B8%25255D.png?imgmax=800" width="654" height="399"></a>

Yep, the selected grid actually has a path, like how you would navigate the file system.  Let’s see what happens with a `cd`.

<a href="http://lh4.ggpht.com/-R3wQmpiA7dw/UBXObb7FNsI/AAAAAAAAAL8/z3mgZwnFLok/s1600-h/image%25255B15%25255D.png"><img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lh3.ggpht.com/-mdRas9rg4gs/UBXOb4W6z7I/AAAAAAAAAME/pNH-1jzMbGA/image_thumb%25255B11%25255D.png?imgmax=800" width="654" height="399"></a>

Cool, you can `cd` into the child “directory”, and it’ll automatically select the item in the tree view as well.  What if you’re lazy and don’t want to type?

<a href="http://lh3.ggpht.com/-QgZ0iBA1AKw/UBXOcPU9uDI/AAAAAAAAAMM/iy9qHsS0zHA/s1600-h/image%25255B20%25255D.png"><img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lh5.ggpht.com/-YV-f5-aPnP0/UBXOcRFGPkI/AAAAAAAAAMU/oo85Qg9fohU/image_thumb%25255B14%25255D.png?imgmax=800" width="654" height="399"></a>

Wildcards are supported.  And because the visual tree doesn’t exactly require unique names, I needed to trick it by adding a number after each duplicate item.  So the above matches the third Rectangle child of the Grid.

# Code Injection

One of the cool things about Javascript is that it’s so darn easy to test.  You make a change, save, reload, and you’ll immediately see if something worked or not.  This feedback loop is so fast it changes how you work and formulate ideas.

In the static world, we don’t really have this luxury, and especially not when you’re working on a large project, which at work, takes just under a minute for a full rebuild.  And this is on a monster machine.  Because of this, we had to employ tricks and workarounds to speed things up, like messing with build configurations and build output paths to minimize duplicate work.  Despite that, it’s still a pain to wait for the application to start and all that jazz.

What if we could do the super fast feedback loop development, in a static world?  Well, now you can!

It starts with a simple function:

``` powershell
function replace-command([string]$msg = 'hello world') {
    $action = { [system.windows.messagebox]::show($msg) }.GetNewClosure()
    $cmd = new-object galasoft.mvvmlight.command.relaycommand([system.action]$action)
    $selected.target.command = $cmd
}
```

The above function will replace anything that has a `Command` property on the target, like a Button or MenuItem, with a MessageBox showing a message.  For the curious, `GetNewClosure` is needed so that $msg is available within the inner script block.  Unlike C#, closures are not automatic.

Since PowerShell is dynamic, if you need to make a change, simply save the script, reload it with a dot-source, which will overwrite the existing function, and then set the target’s `Command` property again.  Awesome!

The only annoyance is converting PowerShell code back into C# code once you’re done.

# Evolution

If you made it this far you didn’t forget about my comment about untargeting .NET 4 and PS v3.  Well, changes have been [merged](https://github.com/cplotts/snoopwpf/commit/16030418b14778029d10e198b288b4efa9bad65c) to the main branch!  Soon the masses will be able to experiment with supercharging their applications with PowerShell!

I’ll likely continue working on my [fork](https://github.com/bling/snoopwpf) as there’s still more goodies I’d like to add.  Stay tuned!
