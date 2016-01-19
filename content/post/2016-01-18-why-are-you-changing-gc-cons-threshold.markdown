---
date: "2016-01-18T14:34:38-05:00"
title: "Why are you changing gc-cons-threshold?"
tags: [ 'emacs' ]
---

# The basics

The [garbage collection][2] in Emacs is very simple.  You allocate some bytes and once you pass a certain threshold, it garbage collects.  That's it.

# The problem

The default value for `gc-cons-threshold` is quite low by modern standards -- it's only 800KB.  But is that actually a problem?  Emacs is known to have poor defaults, but most of the time defaults are chosen because they work most of the time, and something as crucial as `gc-cons-threshold` was *probably* chosen with at least some thought.  But if that's the case, then why is everyone (including some popular distributions) increasing the default value?

<!--more-->

# The performance hit

I can only speculate that one of the reasons is [flx][1].  On their readme they outline a sample performance test which shows that garbage collection accounts for a significant portion of the time, and that once you increase the threshold you see a dramatic performance improvement.  flx is what drives a lot of fuzzy-matching packages (which tend to very popular), so I think it has a viral effect of forcing everyone to increase the threshold.

But maybe it's not just one package.  Maybe it's also from posts like the one from [/r/emacs][4] a couple months ago which recommended to increase `gc-cons-threshold` to improve startup time.  Indeed, it improved my startup time.  However, I went overboard -- I increased it to 1GB, thinking that RAM is fast.  Actually, it's not.  If you set it that high, Emacs will freeze for ~20 seconds when it eventually garbage collects (this took me a while to track down), which is completely unacceptable when it happens in the middle of typing some code.  But even at 100MB, if I paid enough attention I would be able to notice the split second of lag when garbage collection occurs.  How am I supposed to determine the optimal value between speed and lag?

# The default

OK, is the default value actually bad?  I changed the value of `garbage-collection-messages` to `t` and I was simply blown away with how often GC happens with the default threshold.  Operations like `package-list-packages` would spawn multiple collections.  Everyday actions like completion, snippet expansion, and even `ls` a couple times in `eshell` would trigger garbage collection.

It turns out that the default behavior is to garbage collect very often.  And because there is so little garbage to collect each time, you will not notice any lag.  The problem, of course, is when you use memory-intensive features like [flx][1] or [helm][3] on a large collection.

# The fix

Unsurprisingly, the fix is actually mentioned in the official documentation of the variable:

> By binding this temporarily to a large number, you can effectively prevent garbage collection during a part of the program.

Armed with that knowledge, the fix is quite straightforward:

``` cl
(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold 800000))

(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)
```

This works surprisingly well.  While the minibuffer is open, garbage collection will never occur, but once we make a selection, or cancel, garbage collection will kick off immediately and then revert back to the default, sensible behavior.

No more random freezing!  Success!

And if you still want to take advantage of the speed boost at startup, simply set the value in a `let` expression, like this:

``` cl
(let ((gc-cons-threshold most-positive-fixnum))
  # existing init code
  )
```

# Corollary

With this new found old trick, I've started experimenting with the opposite extreme.  A value of `100` is so low that simply moving the cursor 10 times would trigger a GC.  Bulk operations like updating all my packages is noticeably slower (heavy in CPU and memory), but normal everyday Emacs continues to be very snappy.

[1]: https://github.com/lewang/flx
[2]: http://www.gnu.org/software/emacs/manual/html_node/elisp/Garbage-Collection.html
[3]: https://github.com/emacs-helm/helm
[4]: https://www.reddit.com/r/emacs/comments/3kqt6e/2_easy_little_known_steps_to_speed_up_emacs_start/
