---
layout: post
title: "Vim in Emacs Bootstrap"
date: 2013-09-09 20:00
comments: true
categories: ['vim','emacs']
---

Did I wake up on the wrong side of the bed?

My New Year's resolution for 2013 was to learn Vim. I was so new to Vim that I did not even know how to [join lines][1] properly. However, I was diligent, patient, and stubborn enough to stick at it. It didn't take long for me to [fall in love][2]. I even ended up writing a [plugin][3] for Vim that got so popular that I was writing VimL as a second job.

Sounds like I'm pretty happy with Vim (and I am), so why am I trying Emacs?

Curiosity is a major reason. But more I think the philosophy of Emacs fits my personality better. The Vim community is very much divided into two camps: the text editor people, and the people who try to turn Vim into an IDE. I am in the latter. My vim [distribution][4] has over 90 plugins. While I haven't yet run into Vim's limitations of trying to use it this way, I can already see the walls coming up...

But here's the thing, I'm addicted to **modal editing**, not Vim.<!-- more --> It just so happens that Vim is the best implementation of modal editing, but Emacs has something that does a pretty damn good job too! And it's none other than [evil-mode][5].

With evil-mode, it's finally possible to have the best of both worlds. The power of modal editing with the near limitless extensibility of Emacs.

And as an added bonus I can finally have an excuse to learn a Lisp dialect. I discovered with Vim that customizing your editor is an incredible catalyst for learning a new language. It wasn't my intention to memorize a sizable portion of the VimL standard library when I started using Vim, but it happened anyway once I started tweaking and customizing...

My goal is that by the end of this post you'll have a working Emacs installation with Vim keybindings out of the box.

# Back to Basics

The best way to learn is to start from scratch. And so I did exactly that starting with the built-in tutorial `C-h t`. While the purpose of this blog post is to get modal editing working in Emacs, you're not going to be able to make *everything* modal, so you still need to know basic commands to navigate around.

# Things you need to know

There are a couple important Emacs keys that you should know.

*  `C-g` is the universal "get me out of here" key, equivalent to `C-c` in Vim.
*  `C-h` is the "help" prefix. `C-h C-h` will show you all possible options. I've found that I use `C-h f` very often, which is used to lookup help for functions.
*  `C-x` is a also very important, as it's the prefix for many common things like saving and finding files.
*  `C-c` by [convention][11] are used for many things, including the equivalent of `<leader>` for user customizations when followed by letters, but also for major and minor mode bindings.

# Setting up your "vimrc"

In Emacs, this is the `~/.emacs` file. But just like in Vim, where you usually have a `~/.vim` directory for various plugins and configuration, Emacs has the `~/.emacs.d` directory. As an added bonus, `~/.emacs.d/init.el` is automatically loaded, so if you put your dotfiles up on GitHub it's as simple as cloning it to `~/.emacs.d`.

# What's with the (((())))?

Going through the documentation is one thing, but making the first change to your `~/.emacs.d/init.el` file is daunting, at least for me it was. While Vim also has its own scripting language, VimL, it is much more newbie friendly.

How do you turn on line numbers? You add `set number` to your vimrc. It's simple, straightforward, and obvious. You don't even know you're scripting in Vim; it just looks like a configuration file at this point. How do you do that in Emacs? First you search on Google, which links you to this [EmacsWiki][6] article. If that doesn't scare you from using Emacs I don't know what will.

The short answer is, you add `(global-linum-mode t)` to your `init.el` file. Right off the bat the questions would be, is that a variable, a function? What is `t`?

Configuring Emacs throws you into Lisp from the get go, so what you want to do is actually read [Introduction to Programming in Emacs Lisp][7].

# Lisp basics

You're going to be seeing a lot of Lisp, so let's summarize the basics:

*  `set` will set a variable, but you will rarely see this.
*  `setq` is *very* frequently seen. The q stands for quote, which will sidetrack you to understanding what a [quote][8] is.
*  `setq-default` sets a variable if it's not already set/overridden.
*  `defun` defines a function.
*  `-p` by convention is added to functions that return true or false (the p stands for predicate).

Now that things are a bit more readable, we can begin setting up our configuration to get evil-mode installed.

# Package management

Emacs 24 comes with built-in [package management][9]. The default GNU repository doesn't really have many packages, but luckily there's a community driven repository named [MELPA][10] where up to date packages are built directly from GitHub.

So, let's add the MELPA into our `~/.emacs.d/init.el` file:

``` cl
;;; this loads the package manager
(require 'package)

;;; here there's a variable named package-archives, and we are adding the MELPA repository to it
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

;;; loads packages and activates them
(package-initialize)
```

OK, straightforward so far.

# Installing evil

Next up is the all important `M-x` binding (on modern keyboards M is the Alt key). This is sort of like Vim's `:` where you can type commands. Here we are going to do a `M-x package-refresh-contents RET`. In Emacs, `RET` is the convention for `<CR>`. This will refresh the repository of available packages. And finally, `M-x package-install RET evil RET`.

And now it's installed!

It's not enabled by default, so we need to append the following lines to our `init.el` file:

``` cl
(require 'evil)
(evil-mode t)
```

Finally, `C-x C-c` to quit Emacs and restart it. If you're feeling adventurous you can use `M-x eval-buffer RET` instead.

# Finale

Congratulations! You have a working Emacs installation with Vim modal editing!

You may notice that in addition to `C-c`, `C-h`, and `C-x` that I mentioned earlier, `C-u` will not scroll up half a page as you would expect. This is because by default this is mapped to the Emacs `universal-argument` function, which is used for repeating. You can of course customize all of this, but I'll let you take it from here...

And so there you have it!

TLDR: `git clone https://github.com/bling/emacs-evil-bootstrap.git ~/.emacs.d` will automate this entire blog post and let you try Vim in Emacs in 10-20 seconds.



[1]: http://stackoverflow.com/questions/14107198/vim-delete-whitespace-between-2-lines
[2]: http://bling.github.io/blog/2013/02/10/love-affair-with-vim
[3]: https://github.com/bling/vim-airline
[4]: https://github.com/bling/dotvim
[5]: http://www.emacswiki.org/emacs/Evil
[6]: http://www.emacswiki.org/emacs/LineNumbers
[7]: http://www.gnu.org/software/emacs/manual/eintr.html
[8]: http://stackoverflow.com/questions/134887/when-to-use-quote-in-lisp
[9]: http://www.emacswiki.org/emacs/ELP
[10]: http://melpa.milkbox.net/
[11]: http://www.gnu.org/software/emacs/manual/html_node/elisp/Key-Binding-Conventions.html
