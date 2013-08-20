---
layout: post
title: "Modularizing VimScript"
date: 2013-08-16 20:22
comments: true
published: true
categories: vim
---

# The prerequisites

First off, there are two very good resources that are required reading in addition to what's provided in the official documentation.  Steve Losh's [Learn Vim the Hard Way][1] is an excellent book and I highly recommend it.  The [IBM Series][2] by Dr. Damian Conway is another great resource.  Without these I would not have been able to do what I have achieved, so thanks to them!

# Where I started

When I first wrote [vim-bufferline][5] and [vim-airline][6] I was very much a newbie Vim scripter and I tried to follow as many existing patterns as possible.  It was evident that the community at large had a very "C-like" mentality, in that most things were done with functions declared in the global scope (I don't know if this still holds true for modern C development, but as an expression I think people will get what I'm saying).  Many of the older scripts (pre GitHub) tended to be large, single file plugins which lived under the `plugin` folder.  For example, [EasyGrep][3] is a 3000+ line plugin that helps you search and replace in Vim.

<!-- more -->

Most tutorials also taught writing functions in this fashion (most likely due to simplicity).  For example, this is from [part 1][2] of the IBM developer series:

``` vim
function! ToggleSyntax()
   if exists("g:syntax_on")
      syntax off
   else
      syntax enable
   endif
endfunction
nmap <silent> ;s :call ToggleSyntax()<CR>
```

We all have to start somewhere, but what I found was that these patterns and practices followed beyond their original intention and into plugins.

I think part of the problem is that Vim has a very unique scoping system, in that you can scope variables to a script, window, or buffer, for example.  People ended up using this as a form of encapsulation:

``` vim
let s:text = ''

function! s:somefile#set_text(val)
  let s:text = a:val
endfunction

function! g:somefile#get_text()
  return s:text
endfunction
```

The `g:` variables are your exposed public API, and the `s:` variables are private.  That's all good, but *everything is still global!*

# Where I am now

There is nothing particular wrong with the approach of using global variables and functions.  Many complex software systems have been designed this way with much success, and often times, they perform much faster than counterparts with "objects" and "polymorphism".

Nonetheless, everything has pros and cons, and the cost of maintenance goes up when you have a bunch of global variables interacting with each other.

The more VimScript I wrote the more I sought for a way to manage complexity and splitting up my code into smaller, manageable pieces.

# Modularizing VimScript

Let's take a look at how we can create an object that is transient, has state, and contains methods you can invoke, like any modern OOP language can do.

``` vim
function! myobject#new()
  let obj = {}
  let obj._cats = []

  function! obj.add_cat()
    call add(self._cats, '(^.^)')
  endfunction

  function! obj.meow()
    for cat in self._cats
      echo cat
    endfor
  endfunction

  return obj
endfunction

" somewhere else
let x = myobject#new()
call x.add_cat()
call x.meow()
```

This might look familiar to some of you.  Yes, it's almost the same as the [JavaScript Module Pattern][4].  Unfortunately, closures are not supported, but otherwise all of the usual benefits apply here, mainly controlled visibility into private state **and** ***transience!***

You can even take this concept further and replicate "static" functions:

``` vim
function! s:object#private_static()
endfunction

function! g:object#public_static()
endfunction

function! g:object#new()
  let obj = {}

  function! obj.public()
  endfunction

  function! obj._private()
  endfunction

  return obj
endfunction
```

Yep, same story as JavaScript here -- `_` variables/functions are "private".

# Where from here?

Does this mean we should throw out procedural programming and go full on object oriented?  Hell no.  [This][7] is what happens when you go too far!  But we should always take a look at what we're doing and use the best tool and technique for the job.  Sometimes that's procedural, other times it's object-oriented.  It pays to be flexible.

[1]: http://learnvimscriptthehardway.stevelosh.com/
[2]: http://www.ibm.com/developerworks/library/l-vim-script-1/
[3]: http://www.vim.org/scripts/script.php?script_id=2438
[4]: https://www.google.com/search?q=javascript+module+pattern
[5]: https://github.com/bling/vim-bufferline
[6]: https://github.com/bling/vim-airline
[7]: http://static.springsource.org/spring/docs/2.5.x/api/org/springframework/aop/framework/AbstractSingletonProxyFactoryBean.html
