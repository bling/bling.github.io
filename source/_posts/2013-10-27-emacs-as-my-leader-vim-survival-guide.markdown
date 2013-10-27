---
layout: post
title: "Emacs as my &lt;Leader&gt;: Vim Survival Guide"
date: 2013-10-27 12:00
comments: true
categories: ['vim', 'emacs']
---

Two months ago I blogged about switching from Vim to Emacs.  Today, Emacs is my main editor.  I'll try to keep this post short and to the point, because there is *a lot* to cover!  But by the end of this post you'll have to answer to the question whether you should give Emacs a try.

# What is a text editor?

If we're just talking about using Emacs as a text editor, then there is no comparison; Vim beats it, period.  But is our job description a text editor?  No.  We are system administrators, software developers, web designers, etc.  A text editor is a tool that we use to do our job (or hobby).  And any tool should be replaced when a better option is available.

One simple example is `grep`.  As a developer, you can immediately gain a productivity boost by replacing it with [ack][31] or [ag][30].  Do they search faster than `grep`?  No.  But since they're so good at ignoring things (like your `.git` directory) that for practical purposes they end up saving you a lot of time.

As a text editor, I think Emacs is quite terrible.  Its key bindings are notoriously bad to the point that something called Emacs pinky exists.  If you're an Emacs user not interested in Vim bindings you should seriously consider taking a look at [god-mode][5] or [control-mode][34].  But where Emacs really excels is all of the things outside of text editing.

> Emacs is a great operating system, if only it had a good text editor.

Well, the nice thing about an operating system is that you can write a text editor for it; that text editor is called [evil-mode][4].

Now, as a text editor, Vim is still better than evil-mode for obvious reasons, so if you're just swapping it out you're at a net loss of productivity in terms of text editing.  However, what you *gain* from all of the other things that Emacs can do far outweighs the missing features.

<!-- more -->

# Enough talk, give me real life examples!

There are a couple immediate advantages that Emacs has that Vim users have been requesting for a long time.  First, is asynchronous operations.  Second, is integration with background processes.  And third, multiple-monitor support.

Here's a quick video illustrating the difference:

<iframe width="420" height="315" src="//www.youtube.com/embed/TuHgGJV2QX0" frameborder="0" allowfullscreen></iframe>

In the video, [flycheck][7], [syntastic][6], [vim-dispatch][27], [ack.vim][36] and [ag.el][35] are used.

# Zero to hero

OK, I've caught your interest.  And now you want to use Emacs and be at the same efficiency as your Vim setup.  I'll be frank with you.  My Emacs setup right now is *still* not as efficient as my vim/tmux/zsh setup.  But I believe with enough time and tweaking I will eventually cross over, hence why I am sticking with it. But to get you started on the right track, here are steps to take.

## Step 0: Install evil-mode

This is a given, but I figured I'd mention it.  This is the magical package which gives you Vim bindings.

Remember though that evil-mode is an *emulation* of Vim; it is *not* Vim!  For example, you might try `cas` and conclude that evil-mode is broken because it is changing a paragraph instead of a sentence.  That is, of course, until you realize that Emacs also has a notion of what a sentence is, and that the default value of `sentence-end-double-space` is true.  Long story short, evil-mode will use Emacs functionality where it makes sense, so if something is not working as expected there is usually a good reason for it.

## Step 1: Resist the urge to Google it...initially

I wasted a lot of time doing the thing most people do first: Google it.  The problem here is that you will find EmacsWiki.  The second problem is that EmacsWiki will contain *a lot* of information, giving you the illusion that it is useful.  The third problem is that you will not know what it old and outdated, old and still useful, or new and useless.  Emacs has been around since 1976, so there is a lot of history go through.

What you actually want to do is read the [Emacs Manual][8].  And you should also read [Introduction to Programming Emacs Lisp][9].  If you are not going to learn how to program in Emacs Lisp, you should just stop now because you're severely limiting the potential of Emacs.

## Step 2: Prepare for a world of hurt\^H\^H\^H\^Hlearning

Vim is difficult to learn because you're learning a new language on how to interact with text.  Emacs, however, is difficult to learn because there is *so much* to learn.  The *default* distribution includes a email client, IRC client, file explorer, shell, and even tetris.  You will literally be learning a new operating system.  And operating systems have many applications; Emacs is no different.  You can choose to learn only one application, the text editor, but if you do that you might as well just stick with Vim.

## Step 3: Learn how to help the help

In Emacs, the prefix key for help is `C-h`.  What this means is you hit `C-h`, followed by another key to invoke help on something.  Typing `C-h C-h` will give you the full list of possibilities.  When I first started, I found I used `f`unction and `v`ariable a lot.  In Emacs, *everything* is a function (this is Lisp after all), so you can find out a lot about Emacs by reading the descriptions of functions.

## Step 4: Understanding key bindings

It's probably way too early to talk about this, but I feel this is a great way that describes the fundamental differences between customizing Vim vs customizing Emacs.

First, let's take an extremely common customization in Vim, where the cursor is centered after jumping to the next match:

``` vim
nnoremap n nzz
```

Emacs does not have a notion of recursive vs non-recursive bindings, so it cannot be configured in the same fashion as Vim (doing it with key bindings would require you to define a throw away key binding in the middle).  However, the way you do it in Emacs is ultimately way more powerful and flexible.  One option is to do it like this:

``` cl
(defadvice evil-ex-search-next (after advice-for-evil-ex-search-next activate)
  (evil-scroll-line-to-center (line-number-at-pos)))
```

An advice lets you add behavior to an existing function without modifying it.  By default `n` is bound to the command `evil-ex-search-next`, so what we're doing here is giving it some advice, such that *after* the command is run, we center the line.  I'm a huge advocate of aspect oriented programming so when I found that this was built into Lisp I was jumping with joy.

Another option is you could bind `n` to a wrapper function which calls these two commands directly.

While any path you take will be incredibly verbose in comparison to how Vim does it, there are a couple key take aways from this example.  One; every key is bound to a function (called a command in Emacs lingo).  Two; every function can be redefined entirely, or attached advice before, after, or around it.  Three; almost 80% of Emacs is written in Emacs Lisp.  This is where the "infinitely extensible" reputation comes from.

## Step 5: Understanding major and minor modes

I've mentioned that Emacs is an operating system multiple times now, but to drive the point home, I want to briefly discuss major and minor modes.  You can have a single major mode and multiple minor modes, although there is [mmm-mode][10] which allows you have multiple major modes.  A major mode is similar to `set filetype` from Vim, and a minor mode is similar to a plugin like [vim-surround][11], which spans all filetypes.  However, the biggest difference is that major modes in Emacs often change key bindings radically.

For example, if you hit `M-x package-list-packages RET` it will open up the package manager buffer.  Inside this buffer, you can use `C-n` and `C-p` to move lines up and down, just like the default Emacs bindings.  But you can also hit `n` and `p` instead of the chords, and keys like `i`nstall, `d`elete, and `h`elp are available to you as well.  Emacs appears to be modal after all!

Similarly, the customize buffer, via `M-x customize-group RET` also sets up its own modal bindings; `TAB` for example will jump to the next option.

In Emacs it is common practice for modes to set up a host of bindings under the `C-c` prefix.  I'm writing this post right now in [markdown-mode][12], so I can use `C-c C-u` to jump up a heading, but that binding will be completely different in a different mode.

Essentially, activating a major-mode in Emacs is not much different from running a separate application on your operating system.

This isn't to say that you can't do the same thing in Vim; in fact, email and IRC clients exist on Vim as well, but comparatively speaking these are rare due to the relative difficulty of implementation, and most are done as experiments.

## Step 6: Actually getting work done

OK, so you've read the manual, you've learned the Emacs way, and you even know some basic Lisp now.  But unless you're getting paid to customize Emacs and write Lisp, you didn't get any work done yet.

With that in mind, the first thing you will need to do is install all of the packages which replicate as most of your Vim setup as possible.

### Auto-completion engines

I'm torn between Emacs and Vim solutions.  With Vim, [YouCompleteMe][13] and [NeoComplete][14] offer amazing and fast fuzzy completion.  On Emacs, neither [auto-complete][15] or [company-mode][16] offer fuzzy completion yet.  auto-complete has a fuzzy match algorithm, but it has to be manually invoked, rendering it inferior to always-fuzzy-on.  While you have to give up fuzzy matching (for now), in exchange you get real documentation tooltips.  This is far superior to Vim's use of the preview window which ends up bouncing your cursor all over the place as the window shows and hides.

company-mode has a unique take on auto-completion where it will reject keystrokes if it doesn't match any possibilities.  It can also search available completions and filter as well, something I've not seen in any other completion engine.

auto-complete is far more popular than company-mode, so you will find that more packages integrate with it, however it's pretty straightforward to write an adapter to get sources to work with company-mode.  I'd say try both and see which one you like more!

Snippets are another huge time saver.  In Vim, you got [UltiSnips][17] and [NeoSnippet][18], whereas on Emacs you only got one contender, [YASnippet][19].

### Moving around

Emacs out of the box has superior capabilities for navigation; the built-in package [ido][38] makes quick work of navigating files and buffers.  You can go a long way knowing just `C-x C-f` and `C-x b`.  However, most people will be used to the capabilities of [ctrlp][20] and [unite][21], which can recursively fuzzy search the project.  In Emacs, [projectile][22] and [filpr][1] will do the trick.

Another powerful package worth mentioning is [helm][25].  Although it shares many similarities with projectile, it also excels in areas that projectile does not, and vice versa, causing me to have both installed.  The situation is similar to me having both ctrlp and unite installed in Vim.

### Fuzzy extended command search

Sublime Text has a very useful feature called the command palette.  It's a fuzzy searchable list of commands that you can use to operate on the current buffer.  Emacs has a very similar feature, called `M-x`, which is bound to `execute-extended-command`.  Unlike Sublime Text, it will not show you a list or description.  The default behavior requires you to type some things and use `TAB` completion.  Luckily, you can get half-way there by installing a package called [smex][2], which will give you the fuzzy searchable list (no descriptions though).

This is a *very* ***very*** commonly used operation in Emacs.  It pains me that the `ALT` key is so hard to reach, requiring you to tuck your thumb under either hand on most keyboards.  The nice thing about Vim bindings though you can easily add normal mode mappings.  I have this bound to `SPC SPC`, so I can just double tap the space to run a command.

### Memorizing key bindings

Emacs bindings are pretty hard to remember (not nearly as mnemonic as Vim keys).  Luckily, the most often used Emacs bindings are prefixed with `C-x` and `C-c`.  This actually makes mixing Emacs and Vim very easy, because you are only giving up decrementing a number (which you can easily rebind), and `C-c`, which most people will be using `Esc` anyway.

[guide-key][3] is an immensely useful package that will tell you all the available keys and what they are bound to after hitting a prefix key.

### File browsers

[NERDTree][23] and [vimfiler][24] are both excellent plugins for Vim that give you a file browser on the side.

I think fuzzy searching is a far more useful and productive way to navigate around, but file browsers hold a niche in my tool belt for when I'm working a foreign project where I don't know where all the files are laid out.  I haven't spent much time with file browsers for Emacs, but there are many available.  The built-in `speedbar` will open up a new frame.  An installable package named `sr-speedbar` will take the speedbar and place it inside a split window instead.

A new kid of the block, released just a couple weeks ago is [project-explorer][26], also looks very promising.

### Your choice of language specific packages

Last but not least, you will need to install mode packages, e.g. `coffee-mode`, `stylus-mode`, `jade-mode`, `js2-mode` etc.

## Step 7: Practice makes perfect

And of course, practice practice practice!

# Some other things to consider

Here are some *subjective* opinions I have on some...softer things to consider...

## Vim developers are *very* tenacious

There is no dispute that Emacs Lisp is by far the superior language when compared to VimScript, but that doesn't stop VimScript plugin developers from making some really amazing plugins and pushing the envelope.  Vim plugin developers always find a way, no matter how hacky the solution might be.  It's fun to be "hacking" instead of "developing" after all.

To illustrate this point, [commandt][37] first came out early 2010, and [ctrlp][20] came out third quarter of 2011.  [projectile][22] and [fiplr][1] both got recursive fuzzy searching the summer of **2013** (yes, *this* year).

## Vim is *much* more popular than Emacs

While popularity and internet stars as a metric does not necessarily correlate with the quality of a product, the side effects will definitely be felt if you use Emacs.

For starters, for every Emacs colorscheme there will be at least 10 Vim colorschemes.  Good luck finding one that works well in the terminal.  I can count on one hand the number of themes I've found usable in the terminal (I use `monokai`).  The irony is that Emacs packages tend to understand your code a lot better, for example `js2-mode` is actually a full-blown parser, but Vim will still highlight more symbols because its colorschemes will define a lot more syntax rules.  The best themes with the most rules for Emacs are currently `zenburn` and `solarized` (unfortunately I'm not a fan of either).

Another effect of popularity is that plugins tend to have more bells and whistles than their Emacs counterparts.  This, coupled with the attitude of Vim plugin developers mentioned earlier, results in a impressive set of plugins that no other ecosystem can match.

## Vim is more user friendly

I've mentioned before that if you want to use Emacs to its fullest potential, you *must* learn Lisp.  Unless you're lucky and the package you're using has a very active and responsive maintainer, you are better off trying to implement that feature or bug on your own and then submit a pull request later.

# Is it worth it?

At the end of all of this, you're probably thinking to yourself, I'm already at `X` level of productivity, will switching to Emacs get me to `X + Y`?

One of the major reasons for me switching was an excuse to [learn a Lisp dialect][39].  Let me tell you; this reason alone is worth it to try Emacs.  Lisp will make you a better programmer by giving you a new perspective.  It will also make you question why all the complicated imperative languages today still do not compare to the simplicity and power that was available to us over 30 years ago.

Yes, the learning curve is high.  But fear not!  You do not have to start from scratch.  You already know Vim, so you got the text editing part covered, which leaves just learning how to do things in Emacs one feature at a time.  If you configure Emacs to use the same key bindings as your Vim config, as I have in my [dotvim][32] and [dotemacs][33] configs, it becomes seamless to switch between the two.  Lastly, you are not picking Vim *or* Emacs, but rather you are picking Vim *and* Emacs!  Use the best tool for the job.

For me, Emacs is my `<leader>` key, the set of customizations that are non-standard to Vim, just like `set nocompatible` is the set of customizations that are non-standard to Vi.


[1]: https://github.com/d11wtq/fiplr
[2]: https://github.com/nonsequitur/smex
[3]: https://github.com/kbkbkbkb1/guide-key
[4]: https://gitorious.org/evil/evil
[5]: https://github.com/chrisdone/god-mode
[6]: https://github.com/scrooloose/syntastic
[7]: https://github.com/flycheck/flycheck
[8]: http://www.gnu.org/software/emacs/manual/
[9]: http://www.gnu.org/software/emacs/manual/eintr.html
[10]: https://github.com/purcell/mmm-mode
[11]: https://github.com/tpope/vim-surround
[12]: http://jblevins.org/projects/markdown-mode/
[13]: https://github.com/Valloric/YouCompleteMe
[14]: https://github.com/Shougo/neocomplete.vim
[15]: https://github.com/auto-complete/auto-complete
[16]: https://github.com/company-mode/company-mode
[17]: https://github.com/SirVer/ultisnips
[18]: https://github.com/Shougo/neosnippet.vim
[19]: https://github.com/capitaomorte/yasnippet
[20]: https://github.com/kien/ctrlp.vim
[21]: https://github.com/Shougo/unite.vim
[22]: https://github.com/bbatsov/projectile
[23]: https://github.com/scrooloose/nerdtree
[24]: https://github.com/Shougo/vimfiler.vim
[25]: https://github.com/emacs-helm/helm
[26]: https://github.com/sabof/project-explorer
[27]: https://github.com/tpope/vim-dispatch
[28]: https://github.com/terryma/vim-multiple-cursors
[29]: https://github.com/magnars/multiple-cursors.el
[30]: https://github.com/ggreer/the_silver_searcher
[31]: http://beyondgrep.com/
[32]: https://github.com/bling/dotvim
[33]: https://github.com/bling/dotemacs
[34]: https://github.com/stephendavidmarsh/control-mode
[35]: https://github.com/Wilfred/ag.el
[36]: https://github.com/mileszs/ack.vim
[37]: https://github.com/wincent/Command-T
[38]: http://www.emacswiki.org/emacs/InteractivelyDoThings
[39]: http://bling.github.io/blog/2013/09/09/vim-in-emacs-bootstrap/
