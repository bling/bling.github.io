---
layout: post
title: "Emacs As My <Leader> 1 Year Later"
date: 2015-01-06
comments: true
categories: ['vim', 'emacs']
---

Last year, I wrote a [Vim Survival Guide][1] for a Vim user switching to Emacs.  In that blog post I wrote:

> My Emacs setup right now is still not as efficient as my vim/tmux/zsh setup.

I got an email from someone a couple days ago asking whether that's still true.  Rather than replying to him directly, I figured I should blog about it since it would make for an interesting topic.

Well, it started out pretty simple.  I used Vim as my text editor, and after switching, I continued using Emacs as my text editor as well.  But as you already know, Emacs is much more than that, and slowly over time, unexpectedly, it took over other parts of my workflow that I thought were untouchable.

<!--more-->

# Victim 1, The Terminal

One of those untouchable things was the terminal.  Vim is at its best when paired with a competent terminal environment, which typically means zsh and tmux.  What is often left out in that recommendation is that it also implies a UNIX operating system.  Well, sometimes that's not an option, and in my case, I had to make do with the Windows machine sitting in front me.

Getting UNIX on Windows is a lot easier these days.  Installing Git alone will get you a decent minimal shell, and projects like [Babun][2] will get you a preconfigured Cygwin environment up in no time.  As great as these options are, you'll always be a second class citizen compared to a real UNIX machine, and you will suffer the emulation performance costs or the odd compatibility problems here and there when switching between Cygwin and native Windows binaries.

Rather than doing all of that, and since I was already using Emacs, I tried `eshell` out for a change -- what was supposed to be temporary, became permanent.  eshell is surprisingly good.  Granted, this was likely only possible because I was a basic terminal user -- my zshrc was no where near as complicated as my vimrc or my init.el.  I also wrote quite a few Emacs Lisp functions by now, which meant that my Emacs Lisp scripting prowess was much better than my non-existent Bash scripting, making eshell even better based on my capabilities.

An expected surprise was that eshell reimplements most of UNIX -- `ls` is Emacs Lisp function, so is `grep` and a slue of other UNIX commands.
Some of you may think that this is NIH syndrome, but guess what?  With eshell as my main shell, I can use Windows, OSX, and Linux interchangeably with the same configuration and same key bindings.  The integration of eshell with other Emacs features is also much more seamless.  `grep`ing for text will put the results into a new buffer, of which I can search to narrow down further, and also opening the files at the matching line numbers.

Before I discovered Babun, I'd joke that the easiest way to get UNIX onto a Windows machine was to extract the Emacs zip file and run the exe.

# Victim 2, tmux

tmux ups your game by allowing you to manage multiple screens at a time.  Most terminal users probably get by this by using tabs in their terminal -- I used iTerm for the longest time on OSX, and still do.  However, using tmux does free you up from OS lock in.  tmux exists on Cygwin for Windows, but the last time I tried it, around of Summer 2014, it had bugs and would segfault, so I had to use screen instead.

Managing multiple windows in Emacs is one of its natural strengths, so replacing tmux didn't take much thought or training.

# Victim 3, Background Processes

With the terminal and multiple screens taken care of, the next step was figuring out how I would run my development servers.  I do a lot of Web and Java development these days, which means spinning up `node` for watching/bundling the client and running `java` processes for the backend.  In the past, I would use dedicated iTerm tabs for each process (or [ConEmu][13] tabs in Windows).  It worked just fine, but having these run in Emacs gives some neat advantages.

Any output is piped directly into a buffer.  And that buffer acts the same as any other buffer, which means you can search, jump around, yank, cut (if read-only mode is off), etc.  You can navigate to and from it just like any other file buffer you have open, and even cool things like defining your own syntax highlighting so that anything that matches `[ERROR]` comes out bright bold red.

Part of development also means killing and spinning up these processes periodically.  In the past, I would Alt-Tab, mouse around, C-c, up, enter, etc.  Now, I have it automated with an elisp function bound to a key.

# Victom 4, IntelliJ

Just kidding!  IntelliJ for Java is untouchable.  I tried the various options available to Emacs but none of them can hold a candle against IntelliJ.

# Victim 5, Me

When I was a Vim user, what annoyed me the most was not being able to use my muscle memory outside of Vim.  I lost so many chat messages by prematurely hitting `Escape` that I had to write a [AutoHotKey][12] script that would disable the key when those windows are open.

As an Emacs user, I was going to say that I want everything to be running inside Emacs.  And while that's somewhat true, if I had to pick only one thing, it would have to be `eval-last-sexp`.  The ability to not only tweak every little detail of your editor, but to do it while it is running is very intoxicating.

When I did web development in the past with Vim, I would make changes, wait for live reload to kick in, and verify my changes in the browser.  This was not slow by any means -- it happened in about 1-2 seconds.  After switching to Emacs, all of a sudden this was intolerable -- it was too slow!  I wanted instant gratification!  These days I jack into my browser with [skewer-mode][10] and evaluate changes directly into the browser.

Am I doing anything that you cannot do in Vim?  Nope.  [browserlink.vim][11] will get you the same experience.  But I think because both editors start from differing philosophies, doing it in Emacs feels natural, whereas doing it in Vim feels forced.

# Turning evil-mode off!

When I first started, I did what most people trying [evil-mode][8] probably do -- I enabled it globally.  Unfortunately, over time this proved to me problematic for me because I developed the expectation that *everything* should have Vim bindings, which was far from reality.  evil-mode comes with integration for some packages out of the box, but you're bound to hit some package which is not supported.  You are left with 3 choices: 1) get repeatedly frustrated as you hit the wrong keys, 2) configure the keymap to have Vim bindings, or 3) suck it up and use Emacs bindings.

But then I realized, despite my desire for modal editing, that is a *learned* obsession.  I didn't start with Vim, I started with Notepad.

With that realization, I turned evil-mode off by default.  When I edit text, I turn it on.  For everything else, I use Emacs bindings.  With my expectations aligned, I don't get frustrated anymore.

# After a year, am I more efficient?

Without a doubt, yes!

As far as editing text is concerned, in my mind evil-mode is, for all practical purposes, on par with Vim.  There might be some obscure feature that hasn't been emulated yet, but in my experience that is usually because a) the feature is so rarely used that it's a waste of time to implement, or b) there is a better, native Emacs alternative.

A year ago, the biggest deficiency for me was the lack of a jump list which spread across buffer boundaries.  Well, rather than waiting for it to be implemented by someone else, I did it myself, and thus [evil-jumper][3] was born.

Fuzzy matching was another biggie for me.  Thanks to all the hard work recently from the maintainers of [helm][4], I don't have to be envious anymore.  Helm literally went from one of my least used packages to most used over night -- prior to this I relied on ido+smex.  [auto-complete][5] and [company-mode][6] aren't there yet, but I suspect it won't be too much longer for them to support it.  As of now, if you truly desire fuzzy auto completion as-you-type, it can be achieved through [emacs-ycmd][7], although setup is more involved as it requires compiling a daemon process.

While I'm mentioning packages, [projectile][14] is a must-have for any Emacs user.

# Considering the switch?

Over the past year there have been a lot more threads lately in [/r/emacs][9] from curious Vim users.  A general theme I've observed is that people want to make Emacs act exactly like how they had their Vim set up.  If you're considering the switch, empty your mind.  Trying to get Emacs to behave exactly like Vim will hinder your growth and you'll probably give up with frustration before ever realising Emacs' full potential.  Remember, there are tons of highly productive Emacs users who do not use Vim or evil-mode -- it's up to you to find out what tricks are up their sleeve...

[1]: http://bling.github.io/blog/2013/10/27/emacs-as-my-leader-vim-survival-guide
[2]: http://babun.github.io/
[3]: https://github.com/bling/evil-jumper
[4]: https://github.com/emacs-helm/helm
[5]: https://github.com/auto-complete/auto-complete
[6]: https://github.com/company-mode/company-mode
[7]: https://github.com/abingham/emacs-ycmd
[8]: https://gitorious.org/evil/evil
[9]: http://www.reddit.com/r/emacs
[10]: https://github.com/skeeto/skewer-mode
[11]: https://github.com/jaxbot/browserlink.vim
[12]: http://www.autohotkey.com/
[13]: https://code.google.com/p/conemu-maximus5/
[14]: https://github.com/bbatsov/projectile
