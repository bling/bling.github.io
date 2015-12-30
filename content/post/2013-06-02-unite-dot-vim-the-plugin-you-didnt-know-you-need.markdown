---
layout: post
title: "Unite.vim, The plugin you didn't know you need"
date: 2013-06-02
comments: true
categories: vim
---

# [Unite.vim][f]

What is this?  If you've never heard of this Vim plugin, then this post is for you.  This is one of those hidden gems in the Vim plugin world that is truly life changing.  I think this plugin is so awesome that I've decided to write a post dedicated to it so that more people know about it.

The plugin is written by [Shougo Matsushita][a].  He has written a lot of other popular plugins, notably [neocomplcache][b] and [vimshell][c].  I use a lot of his plugins, so I started to notice when certain plugins started using Unite as a dependency, like [neobundle][d] and [vimfiler][e].

At first it looked like Unite was just a general purpose library, but I was in for a surprise because it is so much more than that.

<!--more-->

# What is it?

This is the problem I had initially.  The project [homepage][f] describes it as "...can search and display information from arbitrary sources like files, buffers, recently used files or registers."  It goes on to show some usage samples, but there is no "wow" factor.  After reading the readme I still didn't have a clue what the plugin could do.

(edit: After I wrote blog post, Unite's homepage has been dramatically improved with screenshots, animated gifs, and even a kickass logo.  It definitely has a lot of "wow" now.)

It wasn't until I stumbled upon terryma's [vimrc][g] (the author of [multiple-cursors][i] and realized that he replaced [ctrlp][h] entirely with unite).  ctrlp is by far one of the best/most popular plugins and for it to be replacable is no easy feat.

So how do you do it?

# First things first, configuration

Unite is geared towards experienced vim users -- it does not create any bindings by default.  To make any use of it, you will need to create the bindings yourself.  And in certain cases, rather than declaring `g:variables`, you configure it with method calls, like `unite#filters#matcher_default#use(['matcher_fuzzy'])`, but thankfully, like all of Shougo's plugins, the plugin is *very* well documented, so feel free to `:help unite` to figure out how to use the plugin.

If you're lazy, you can go directly to my [vim distribution][z] and take the configuration out of there.

But enough talking, here's some quick demos of what Unite can do...

# What can it do?

## File searching like [ctrlp.vim][h]

```
nnoremap <C-p> :Unite file_rec/async<cr>
```

{{<figure src="/img/unite-ctrlp.gif">}}

Did you notice the async flag?  Unite uses [vimproc][j] behind the scenes, which affords for searching while it populates the file list in the background.  That is amazing!

## Content searching like [ack.vim][k] (or [ag.vim][l])

```
nnoremap <space>/ :Unite grep:.<cr>
```

{{<figure src="/img/unite-grep.gif">}}

Unite can be configured to use `grep`, `ack`, or `ag`; whichever is available.

## Yank history like [yankring][m]/[yankstack][n]

```
let g:unite_source_history_yank_enable = 1
nnoremap <space>y :Unite history/yank<cr>
```

{{<figure src="/img/unite-yanks.gif">}}

To be fair, unite cannot bind to a key to cycle the history, so it's not a 100% replacement.  However, if you only rarely use the yankring then this is a pretty good alternative.

## Buffer switching like [LustyJuggler][o]

```
nnoremap <space>s :Unite -quick-match buffer<cr>
```

{{<figure src="/img/unite-juggle.gif">}}

Notice that `-quick-match` is just a flag, which means you can apply this to any source.

## Bonus

Ever been jealous of Sublime's auto preview feature?  Well, turns out unite has an `-auto-preview` flag that you can add.

# Finale

And that's all I got for now.  I'm still learning more about what this plugin can do, but it's definitely earned its place in my vim toolbox.


[a]: https://github.com/Shougo
[b]: https://github.com/Shougo/neocomplcache.vim
[c]: https://github.com/Shougo/vimshell.vim
[d]: https://github.com/Shougo/neobundle.vim
[e]: https://github.com/Shougo/vimfiler.vim
[f]: https://github.com/Shougo/unite.vim
[g]: https://github.com/terryma/dotfiles/blob/master/.vimrc
[h]: https://github.com/kien/ctrlp.vim
[i]: https://github.com/terryma/vim-multiple-cursors
[j]: https://github.com/Shougo/vimproc.vim
[k]: https://github.com/mileszs/ack.vim
[l]: https://github.com/rking/ag.vim
[m]: https://github.com/vim-scripts/YankRing.vim
[n]: https://github.com/maxbrunsfeld/vim-yankstack
[o]: https://github.com/sjbach/lusty
[z]: https://github.com/bling/dotvim
