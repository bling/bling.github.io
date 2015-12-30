---
layout: post
title: "Smart tab expansions in Vim with expression mappings"
date: 2013-07-21
comments: true
published: true
categories: vim
---

I've been having a small itch for a while now, and it's a very simple thing -- I want to make my tab smarter.  This all starts with a dive into [Emmet][a].  To understand what it is, here's a quick introduction.  First, you type something using its syntax:

```
div>li*4
```

and after you "expand" it, usually with a hotkey, and it gets converted to

``` html
<div>
  <li></li>
  <li></li>
  <li></li>
  <li></li>
</div>
```

As you can imagine, this saves you *a lot* of typing and lets you prototype a web page (or CSS) in no time once you learn the syntax.  It is snippets on steriods!  The Sublime [plugin][b] handles this perfectly.  It maps `<tab>` as the expansion key.  Hitting tab after typing `div>li*4` will expand it and put the cursor at the first `<li>|</li>`.  Then after you type something, if you hit `<tab>` again, it will jump to the next `li`.  It is smart enough to know whether to expand or jump to the next tag.

So how does this functionality look like in Vim?  <!--more-->First, you must install the [zencoding-vim][c] plugin to get this functionality (Emmet used to be named Zen Coding).  However, by default it's mappings are `<C-y>,` to expand, and `<C-y>n` to jump to the next tag.  There are two problems here.  First, these mappings are **really** awkward to type.  And secondly, there are two mappings!  You could, of course, remap it do something else, but let's be honest, `<leader>` whatever just does not compare with `<tab>`.

How can we replicate this functionality in Vim?

# Expression Mappings

Most of the time, you will see people do mappings in Vim like `nnoremap j gj` which is a very simple and straightforward mapping.  Other times you may see something like `nnoremap Q :call CloseWindow()<cr>` where a key is mapped to a function.  But rarely will you see anyone use `<expr>` mappings.  What are these?  Long story short, you can determine what to map based on the return value of the function.  To replicate the above tab behavior, let's first set up a basic mapping:

``` vim
function! s:zen_html_tab()
  return "\<c-y>,"
endfunction
autocmd FileType html imap <buffer><expr><tab> <sid>zen_html_tab()
```

There's a lot of things going on here, so I'll go over them one by one.

* `s:` denotes that the function is scoped to the script.  You can, of course, define the function globally (must be PascalCased or script#prefixed), but I prefer not to pollute the global scope if I don't have to.  The return value is an escaped string which are the keys you want to map.  An additional thing to note is that you need `<sid>` to reference the function in the mapping.
* The FileType autocmd is used to set up the mapping only for HTML files.
* `<buffer>` denotes that the mapping should only apply for the current buffer (without this when you open an HTML file it will apply the mapping globally).
* `<expr>` is the special sauce that lets you to execute code to determine the value of the mapping.

OK, the above doesn't actually do anything yet.  In fact, it's pretty much equivalent to `imap <tab> <c-y>,`.  So let's add some context into it:

``` vim
function! s:zen_html_tab()
  let line = getline('.')
  if match(line, '<.*>') >= 0
    return "\<c-y>n"
  endif
  return "\<c-y>,"
endfunction
```

This is a simple implementation that captures the majority of use cases.  `getline('.')` gets the current line under the cursor.  `match()` is a built-in function which returns the index of the matched regular expression.  I am relying on the fact that Emmet syntax will *not* have an opening <.  This makes the function very simple; if there's an <> then jump to the next tag, otherwise, expand.

And that's all there is to it!  This function won't cover more "advanced" scenarios like nested expansions (although you could cheat by creating a newline), but otherwise it shows that expression mappings are an easy way to get more umph from your mappings.

For more details, contact your local Vim department by calling `:help map-<expr>`.

[a]: http://www.emmet.io
[b]: https://github.com/sergeche/emmet-sublime
[c]: https://github.com/mattn/zencoding-vim
