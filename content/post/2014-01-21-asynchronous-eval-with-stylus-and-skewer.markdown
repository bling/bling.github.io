---
layout: post
title: "Asynchronous Eval in Emacs with Stylus and Skewer"
slug: asynchronous-eval-with-stylus-and-skewer
date: 2014-01-21 16:41:16 +0000
comments: true
tags: ['emacs']
---

You haven't experienced Emacs if you haven't experienced the power of `C-x C-e`.  This is the magical keybinding which evalulates the current line.  Another useful companion is `C-M-x`, which evaluates the current function.

Lisp dialects naturally work with these patterns seamlessly, and once I figured out the possibilities of this I got addicted and wanted it available in *all* of my languages.  It's like having a debugger available all the time.  But unlike debuggers where you inspect and change variables at run time, and then need to translate your changes back to code, in Lisp you just edit the code directly and eval (and repeat until you like the result).

<!--more-->

# Adapting the Pattern to Stylus

Anyone doing serious web development will not be writing CSS directly.  There are many compelling alternatives; the 3 most popular being SASS/Compass, LESS, and Stylus.  On my current project I'm using Stylus, so I adapted this workflow to it.

First, let's start with [skewer-mode][1].  This minor mode lets you connect to a real browser and evaluate to it.  It can evaluate Javascript or CSS on the fly.  It even has a bookmarklet script that allows you to evaluate arbitrary code against *any* website.  Yes, that is amazing!

However, it only supports CSS...so how am I going to use my beloved eval against Stylus code?

# The First Attempt

The first thing I did was do the simplest thing -- convert Stylus to CSS and show it in a temporary buffer.  This turned out to be pretty straightforward.  I came up with the following code snippet:

``` cl
(defun stylus-compile-and-show-region (start end)
  (interactive "r")
  (call-process-region start end "stylus" nil (get-buffer-create "*Stylus*"))
  (display-buffer "*Stylus*")
  (with-current-buffer "*Stylus*"
    (css-mode)))
```

Easy!  It creates an interactive command which takes in a region, then calls out to the external `stylus` command and puts the output into a buffer named `*Stylus*`, and finally shows it and enables `css-mode`.

Now, I just switch to that buffer and `C-x C-e` to my heart's content!  But there was a problem here....Anything I change in the CSS buffer I would have to translate it back to Stylus, which was very annoying, and I might as well do it in the browser directly with Dev Tools if I'm going to do that.

Let's fix that.

# Evaluating Stylus Directly

First things first, I realized that I don't need to show a buffer to interact with it.  So evaluating from Stylus directly actually involved replacing one line of code.  Instead of `(display-buffer)`, I put in `(skewer-css-eval-buffer)`, and viola!!  Now I can eval any Stylus code and have it appear in the browser!

For brevity I've excluded other necessary code like emptying the buffer before compiling Stylus, but you get the idea.

But, there was one last itch I still needed to scratch...

# It was blocking!

All things considered, blocking the UI for 1 second isn't the end of the world.  But it was enough of an annoyance that I felt compelled to fix it!

And with that, I started reading the documentation.  I wish Emacs would provide a categorzied listing of all functions (instead of the [alphabetical listing][2]), because finding what I needed took longer than expected (if you know of such a listing please let me know).

I eventually stumbled across `start-process`, which lets you control asynchronous processes.  Digging through the documentation further, I was able to find `set-process-sentinel`.

And with that, the following snippet was born:

``` cl
(defun stylus-eval-region-async (begin end)
  (let ((process (start-process "stylus" "*Stylus*" "stylus")))
    (set-process-sentinel process 'stylus-process-sentinel)
    (process-send-region process begin end)
    (process-send-eof process)))

(defun stylus-process-sentinel (process event)
  (when (equal event "finished\n")
    (with-current-buffer "*Stylus*"
      (css-mode)
      (skewer-css-eval-buffer))))
```

Basically, what's happening here is that I'm starting an asynchronous process which writes all output into the `*Stylus*` buffer.  I send the region as input into the process, and finally, when the process terminates, which is detected by the sentinel function, it evaluates the buffer.

And now I can eval to my heart's content without blocking!

The full source code (with emptying buffers and other housekeeping) can be found in my [dotemacs][3].

If you haven't already noticed, this is not specific to Stylus and will work with any program which works with stdin/stdout!  Enjoy.


[1]: https://github.com/skeeto/skewer-mode
[2]: http://www.gnu.org/software/emacs/manual/html_node/elisp/Index.html#Index
[3]: https://github.com/bling/dotemacs/blob/master/config/init-stylus.el
