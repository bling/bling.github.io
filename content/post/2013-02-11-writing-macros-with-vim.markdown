---
layout: post
title: "Writing Macros with Vim"
date: 2013-02-11
comments: true
tags: [ 'vim' ]
---
First, let’s start with a Javascript function:
``` javascript
function foo(hello, world,
             how, are,
             you) {
}
```
Now let’s convert that to the following:
``` javascript
function foo(parameters) {
    var hello = parameters.hello;
    var world = parameters.world;
    var how = parameters.how;
    var are = parameters.are;
    var you = parameters.you;
}
```
Here are the macros I used to do this:
``` vim
let @r='di(iparameters^[/\{^M2o^[kpg`[v`]Jgv:s/\s//g^M0:try|exe "norm! @q"|endtry^MA;^[V:s/,/;\r/g^Mv``='
let @q='ywivar ^[pa = parameters.^[f,^[l@q'
```
<!--more-->

Note that if you copy paste the above into your vimrc it will not work. The `^[` and `^M` found are actually single characters, not two. To input this properly you will need to chord it in input mode with `<Ctrl-V>`. So for `<Esc>` you would chord `<Ctrl+V><Ctrl+[>`.

So, when I'm inside the parameters of the function, I can hit `@r` and it will perform the refactoring. Now let’s break it down step by step.

# @q The first macro

This is a recursive macro which takes something like `a,b,c` and turns it into `var a = p.a,var b = p.b,var c = p.c`. Let’s see how that’s done.

1. `yw` `i` `var` `<Esc>` `p` Yanks the word and enter insert mode, type var, exit insert mode and paste the just yanked word.
2. `a = parameters.` Append and fill in parameters.
3. `<Esc>` `f`, `l` Exit insert mode, find the next `,`
4. `l` `@q` Adjust the cursor position and recursively call itself.

Recursive macros terminate when the first error occurs. In this macro, that error is when there are no more commas left.

# @r The second macro

The is the macro that should be invoked, and references the `@q` macro.

1. `di(` Deletes everything inside the brackets.
2. `i` parameters Enter insert mode and type parameters.
3. `<Esc>` `/{` `<CR>` Leaves insert mode and finds the next brace.
4. `2o` `<Esc>` `k` `p` Creates two empty lines and pastes what we deleted into the first line.
5. ``g`[v`]`` `J` Visually select what we just pasted and join them all into a single line.
6. `gv` `:s/\s//g` `<CR>` Reselect the visually and delete all whitespace.
7. `0` Move to the beginning of the line.
8. `:try|exe "norm! @q"|endtry` `<CR>` Macros will terminate on the first error, even if referencing another macro. Wrapping the other macro with try|endtry swallows the error and lets the current macro continue.
9. `A;` `<Esc>` Append ; to the end of the line.
10. `V` `:s/,/;\r/g` `<CR>` Visually select the line, replace with carriage returns.
11. <code>v=``</code>  Visually select from the current cursor position back to where it was originally was, and format.

Now is this the best way to do it? Probably not. I would not be surprised if someone was able to do it with less keystrokes or a single macro.  But hey, it was fun learning experience, and ultimately I turned all of that into two keystrokes that can be reused many times.

I posted this on [vimgolf](http://vimgolf.com/challenges/511991607729fb0002000003) so let’s see how other people solved the same refactoring!
