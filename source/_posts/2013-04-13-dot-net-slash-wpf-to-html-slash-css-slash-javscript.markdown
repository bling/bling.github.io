---
layout: post
title: ".NET/WPF to HTML/CSS/Javscript"
date: 2013-04-13 11:58
comments: true
categories: [ coding ]
---

# In the beginning...

For the vast majority of my career I'd say I was a Microsoft guy.  I took Java in university and toyed around with Linux at home, but what paid the bills was my knowledge and expertise in Microsoft technologies that I've built up over the years.

Then Metro and Windows 8 came, and the writing was on the wall.  Microsoft really screwed up, and despite their best efforts they could not stop the avalanche that was Node and HTML5.  Everyone was moving to HTML5, and even Microsoft themselves could not ignore this as now they're supporting hosting Node on Azure.

People who have been in the industry for a long time will say this is just the same desktop vs web debacle and that it is cyclical and that people will realize that the web isn't good enough and go back to desktop applications.  But I think this time is different.  This time around, the browser has hardware acceleration.

Performance has always been the deciding factor for going back to the desktop.  I don't think that argument holds true anymore.  It's clear you can build some amazing applications on the web now that perform well.  You can build an IDE in the browser, like [Cloud9](http://c9.io), or you could create impressive animations like [Famous](http://famo.us) demonstrates.  And even 3D games are possible now.

The web is here to stay, and with more and more people having phones and tablets as their primary computing devices (and _not_ a desktop), naturally the technologies we use to build around these devices become more important, i.e. technologies that are cross platform and work on every device from phone to desktop.

So what happens when you throw a C#/WPF guru into the water with no knowledge of HTML, CSS, or Javascript?

# And then there was pain...

From Friday to Monday, I went from a Windows 7 machine with Visual Studio, Resharper, PowerShell, Blend to a OSX machine.  I left out the tools on purpose, because literally I had none.  The only thing I knew was that I would be working on HTML/Javascript and I'd have to bring my own knives to the kitchen.

Except that I had no knives...

# Baby steps

I was comfortable with the command line, since I'm a huge Linux fan and prefer a CLI over a GUI most of the time.  But it became clear that I had acquired quite a bit of PowerShell knowledge in my previous efforts to force myself to learn it, i.e. replace `cmd.exe` with `powershell.exe`.  When I tried to do `ls | % { $_.Length }` I was in for a sad realization...these aren't objects anymore.  Damn, all that muscle memory can't be used here.  Damn you vendor lock in!

But as you can see, I still used `ls` instead of `dir` or `gcm`, so I was already in this weird world of mixing UNIX with PowerShell, and moving back to UNIX wasn't too bad since I didn't have to remember a whole new set of commands for common use cases.  Although it annoys me from time to time that I cannot just `(get-date).addweeks(3)` from the command line anymore, I'm going to have to live without it.

Next up was getting my environment set up.  A quick Google search showed that [Homebrew](https://github.com/mxcl/homebrew) was the hotness, so I installed it, and yes, it was pretty cool.  It still has a ways to go before it's comparable to Linux package managers like `apt-get` or my favorite, Archlinux's `pacman`, but that is understandable since OSX is not built from the ground up using package managers like Linux distributions typically are.  For the most part, it worked as advertised, and after `brew install git` I was ready to check out the source code.

# Making the first commit

Naturally, the first thing I did was download [Webstorm](http://www.jetbrains.com/webstorm/).  Programming without an IDE, yeah right!  I'm a professional!

Alright, let's get working.  Let's start up Webstorm.  OK, it's loading...loading...loading...loading.  OK, great, that's a little faster than Visual Studio, so I'm happy.  OK, it looks familiar.  It's got a side bar with my files, it's got navigation like Resharper, let's start working!

Blah blah blah, type type type, `this.` bam!  What the hell?  Why did autocomplete just list everything in the project?  I'm in the current file and clearly it only has 4 properties defined.

# And so it starts

As it turns out, `this.foo` is the same as `this['foo']` in Javascript, effectively making every object into a dictionary.  Webstorm's take on this dynamic behavior is to give you every possible option in the project, effectively turning the feature into a glorified spell checker.  Webstorm has an option to disable this, so I did and now it behaved more like what I expected.  Nonetheless, one thing was crystal clear -- the "this dot" method of working (and discovering the API) is not possible anymore in the Javascript world.

It was apparent now that the IDE was still in its infant stages.  It had some refactorings built in, but for the most part it was not remotely comparable to what was available in Resharper/C# or IntelliJ.

I have always been a big proponent of tools.  And back in the .NET days I found it incredibly frustrating when some coworkers preferred working _without_ Resharper.  Yes, it was much faster.  But even so, even after waiting for Resharper during its sluggish moments, it saved you time in the end, which in my mind meant you were more efficient with your time.

I consider myself lucky because if it weren't for Webstorm being in its infant stages, I probably would not have done what I was going to do next...venture into vim.

# Vim

I still can't remember the exact reason why I decided to learn Vim.  The majority of my coworkers were using Sublime Text.  Maybe I was stubborn and wanted to be different.  Maybe I was curious and wanted to see why this 30 year old editor is still so popular.  Whatever the reason, I decided to use Vim code turkey and refused to open anything else up.

The rest is [history](http://bling.github.io/blog/2013/02/10/love-affair-with-vim/).

Don't get me wrong, I was _hugely_ unproductive for the first couple weeks.  But I can confidently say that as a proficient Vim user that I am now, I am *far* more efficient than I was before.

# How much is your time worth?

{% img /images/editor-learning-curve.png %}

I can vouch for this popular comic because I have tried every editor on there (yes even Emacs) and I can confirm that it is true.  There really is no contestant that can match the speed and flexibility of modal editing (and why most other editors out there have a vi emulation mode).  New users are often confused why the default mode in vim's normal mode is...normal mode and not insert mode (like every other editor).

As it turns out, the majority of our time as programmers are spent *reading and editing* text, not writing it.  And that is why vim's normal mode is normal mode.  Right off the bat you have 26 different commands that you can use to operate on text.  Add a shift, and you have another 26 commands.  In normal mode, you have 52 unique operations that is a single/double keystroke away!

Whether it's vim, or emacs, or Sublime text, invest in your editor and learn what it can do for you.  Even if it's just a couple seconds saved here and a couple seconds saved there, do realize that as programmers we stare at a text editor the vast majority of our working hours.  And all those seconds add up.

# Javascipt was easy to learn

Well, for me it was.  [JSHint](http://jshint.com) caught all the newbie mistakes.  C# already had lambdas and closures, so programming in the functional style of Javascript was weird at first, but ultimately it was a subset of the features available to C#.  Basically, if I were to program in C# like I did in Javascript, it would look like this:

``` csharp
public void Main() { // this is effectively window
    var namespace = new {
        foo = new {
            bar = new {
                create = () => {
                    return new {
                        hello = () => {
                            Console.WriteLine("hello world");
                        };
                    };
                }
            }
        }
    };
    namespace.foo.bar.create().hello();
}
```

Yes there is variable hoisting, privileged vs public functions, truthy and falsey values, prototypical inheritance, etc. but like any language, this is just syntax.  You read tutorials, you try it out, you struggle against your previous habits, but then you figure it out.

# Javascript changed the way I think

There is something incredibly liberating to just add some random property to an existing object, or change its prototype altogether.  At first I fought against this quite heavily.  We need constants!  We need well defined interfaces!  But in the end, it didn't matter.  We had some conventions, we followed them, and everything worked just fine.

Over time all the things I thought I needed, like intellisense, well defined interfaces, static analysis, I didn't actually need them.  Sure, they are nice to have around, but I was productive all the same without them.  And the users using our application didn't care whether it was written in C#/WPF or in HTML/Javascript, as long as it did was it was supposed to do.

Ultimately, what still mattered were architectural decisions.  We still had services, models, and views for properly separating data from business logic and presentation.  We had unit tests which tested all the functionality.  All of these concepts were very important in C# and WPF, and they are just as important here.

# CSS was a huge pain

Going from XAML to CSS was extremely annoying and where I've struggled the most with the transition.  If you want to vertical center something in XAML, you set `VerticalAlignment=Center` on it and you're done.  How do you do that in CSS?  Well, you could hack it with `table-cell`, or you could hack it with negative margins, or you could hack it with absolute positioning, or `line-height` or something else.  But point is, they are all hacks.

Coming from XAML, CSS is one big hack.  I want to create a grid that resizes to the window size, and is always 30% left side and 70% right side.  In XAML, I just do this:

``` xml
<Grid>
    <Grid.ColumnDefinitions>
        <ColumnDefinition Width="3*" />
        <ColumnDefinition Width="7*" />
    </Grid.ColumnDefinitions>
</Grid>
```

In CSS, here's one way:

``` css
#left { float: left; width: 30%; height: 100%; }
#right { margin-left: 30%; width: 100%; height: 100%; }
```

Again, more hacks.  And it'll only work if the parent element has a size defined.

Or you could do it this way:

``` css
#left { position: absolute; left: 0; right: 70%; bottom: 0; top: 0; }
#right { position: absolute; left: 30%; right: 0; bottom: 0; top: 0; }
```

But it's not going to work if the parent element doesn't have a position of `absolute` or `relative`.

Once I let go of trying to be "correct" from a XAML point of view and just accepted that CSS is just hacks over top of a document model that was never designed to be used like it is today, I actually really enjoyed CSS.

It became a fun challenge, to be presented with a UX design and then think about what kind of hacks I'd have to do to make it look exactly the same.  Pseudo elements became my new best friend.

There was no such kind of fun in the XAML world -- if the UX designer could do something in Illustrator, I can do the same in Blend no problem.  There was no challenge.

It was all fun and games until...

# Enter the beast...Internet Explorer

If you charged X amount of dollars for a project, it should be X raised to the number of versions older than IE10 you have to support.  If it's IE9, it's X^1.  If it's IE8, it's X^2.  How about IE7, X^3 !

That would cover the cost of sheer annoyance and frustration that developers and UX designers will be to face, not to mention the increased amount of time to support these older browsers.  Oh, you want to support responsive design?  Ooops, IE8 doesn't support media queries.  Oh, you want to have shadows and gradients, well you're only going to get mono colored boxes instead.  Oh, you want it to run fast?  Here, take a 20x performance hit instead.

If you could do it, my recommendation for supporting IE is to have the page be one big fat button that spans the entire screen that says inside with two buttons: install Chrome, or install Firefox.  It worked for Flash and Silverlight!

# Back to an IDE...maybe?

I never did venture back.  With my stubbornness to stick with Vim, I ended up installing plugins and optimizing my workflow around it.  I even created my own [distribution](http://bling.github.io/dotvim).  Chrome became my pseudo-IDE and I used its debugging tools heavily.  I used [LiveReload](http://livereload.com) from time to time.  And coupled with a zsh terminal I had an extremely productive development environment.  In the end I didn't have a reason to use Webstorm anymore because at this point it *slowed me down*.

# Finale

Wow.  I didn't expect this blog post to be this long.  But if you got this far I hope you enjoyed the read, because I had fun writing about my experiences.
