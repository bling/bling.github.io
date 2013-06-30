---
layout: post
title: "Love Affair with Vim"
date: 2013-02-10
comments: true
categories:
 - vim
 - software tools
---
It wasn't too long ago when I was a full-time C# developer and my environment was Visual Studio eight hours a day.  Then, I became a web developer over night cold turkey writing Javascript and CSS.  It's one of the benefits of working for a consulting company.

You might think what does that have to do with the title of this post?  Well, originally my plan was to write a blog post contrasting on the differences between Javascript and C#, as well as the development environments and deployment platforms.  But really, what I really wanted to write about was Vim.

Moving from Visual Studio to Vim was a progression through different editors and environments.  The first thing I used to write Javascript was Webstorm.  Over time I realized that you didn't really need an IDE to write Javascript/CSS.  Then, I used Sublime Text for a little bit.  But ultimately, I settled on Vim, and stayed there.

My stubbornness turned out to be beneficial when I was learning Vim because the first month was absolutely painful.  I remapped all of my arrows keys to do nothing to force myself to use hjkl.  Eventually I got the hang of it, and now I definitely have the muscle memory that makes me much more productive when editing (and reading) text.

<!--more-->

By default Vim is just a text editor.  But I work on a project, so like most lazy people I searched for prepackaged plugins and came across two popular distributions: [spf13](https://github.com/spf13/spf13-vim) and [janus](https://github.com/carlhuda/janus).  When I installed them, it was like someone took over Vim and made it change into a completely different beast.  I didn't know how to use it anymore.

I took a step back.  I forgot where I got this advice, but I think anyone using Vim needs to do this: *start your own vimrc from scratch*.

I took a look at all the settings that spf13 and janus changed.  I copied them to my vimrc *one by one*, and also `:help`ing each setting so that I knew exactly what it changed.  I must say, Vim's documentation is some of the best and most comprehensive of any tool I've worked with.  It was incredibly helpful in my progression.

Then, I did the same thing for plugins.  And the nice thing was that most plugins followed the Vim pattern of having good documentation.  After installing `fooplugin`, I just `:help fooplugin` and I got all the information I needed to know about the plugin.

I became obsessed with optimizing my vimrc, and trying out different plugins on a daily basis.  And because I was very adamant with trying one plugin at a time, I got to know them very well.  I knew about how to turn certain settings on and off, how to configure their bindings, and more importantly, how it interacted with all of the other plugins I have already installed.  Over time my vimrc became a full blown distribution in its own right, highly customized to my personal work habits.

However, even though I recommend that anyone interested in taking their Vim skills to the next level should do this discovery that I have done, there are certainly classes of plugins that I deem to be *must-have* for any Vim user and I wanted to highlight them here.

# Plugin Management

First things first you will need one plugin to rule them all!  [Pathogen](https://github.com/tpope/vim-pathogen) changed the way people install plugins by utilizing git submodules.  This has the pros and cons of git submodules, i.e. they track a specific version of the external git repository, so if external plugins are updated frequently you have to manually update all your submodules.

However, more often than not, you just want the latest version.  [Vundle](https://github.com/gmarik/vundle) takes the management one step further and will automatically grab source code from Github for you (as well as automatically updating everything to the latest version).

The last one and least known is [NeoBundle](https://github.com/Shougo/neobundle.vim), which is like Vundle on steroids.  It adds a whole ton of new features like allowing you to specify installation steps for compiling something.

# Fuzzy File Searching

This was the major game changer for me and changed the way I worked.  Naturally, proper Vim technique forces your hands to be on the home row, which makes reaching for the mouse (or even the arrow keys) to be inefficient.  Therefore, the fastest way to open a file is usually to type its name.

[CommandT](https://github.com/wincent/Command-T) (written in Ruby) is noticeably much faster than [CtrlP](https://github.com/kien/ctrlp.vim) (pure VimScript), but CtrlP has a lot more features.  There's also [FuzzyFinder](http://www.vim.org/scripts/script.php?script_id=1984), which I have not tried.

# Autocomplete and Snippets

There are various contenders here.  Generally, you'll find that people fall into two camps.

1. [Snipmate](https://github.com/garbas/vim-snipmate)/[UltiSnips](https://github.com/SirVer/ultisnips) + [SuperTab](https://github.com/ervandew/supertab) + [AutoComplPop](http://www.vim.org/scripts/script.php?script_id=1879)
2. [neocomplcache](https://github.com/Shougo/neocomplcache) + [neosnippet](https://github.com/Shougo/neosnippet)

Snipmate is an older implementation of snippets which is getting replaced with UltiSnips.  Supertab gives you an easy way to trigger omnicompletion with (you guessed it) tab, and AutoComplPop is for automatically showing the popup as you type.

Neocomplcache is a very powerful completion plugin.  It runs a little slower than SuperTab because it does a lot more, but I find the performance acceptable so that's what I'm using.  And I choose neosnippet over the others simply because it's by the same author and thus has better integration (e.g. available snippets will appear in the list).

And of course, a good collection of snippets like [honza](https://github.com/honza/vim-snippets)'s collection.

*edit*: Since I last posted this another autocomplete plugin has taken the Vim world by storm.  It is none other than [YouCompleteMe](https://github.com/Valloric/YouCompleteMe).  This is a fantastic plugin which shows a lot of promise.  It does not have as many features as neocomplcache yet, but it is improving every day and has a large community gathering around it.  Things can only get better!

*edit 2*: [neocomplete](https://github.com/Shougo/neocomplete.vim) is the next generation version of neocomplcache, and despite being in its infancy is showing great progress and has most (if not all) of the features of neocomplcache.  It requires you to recompile vim with lua support, but has the added benefit that it is way faster than before, and unlike YouCompleteMe (which officially does not support Windows), it works very well on Windows as well.

# And that's it!

What?!  No file browser?  No buffer manager?  Yes, I have all of those installed as well.  In fact, I have over 50 plugins installed in total.  But in my opinion, they are not *killer* features.  I can live without them.  But if I didn't have fuzzy searching or completion/snippets, I would feel a little too naked.

Out of the box Vim has some interesting defaults, mainly for backwards compatibility with Vi, but I think it's safe to say that anyone who uses Vim seriously will have a custom vimrc.  If you're just starting out and don't know what to change, [sensible](https://github.com/tpope/vim-sensible) is a good set of defaults.

Vim has changed my work habits dramatically.  I think and dream Vim.  I install Vim plugins in my browsers.  And every day, she still teaches me new tricks.  It's quite exhilarating!

If you've read until this point you might be interested in the full set of plugins that I'm using.  If so, head over to my [vim distribution project](http://bling.github.com/dotvim/)!
