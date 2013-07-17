---
layout: post
title: The flight of an open-source project
date: 2013-07-15 10:00
comments: true
published: true
categories: vim
---

# Welcome aboard!

Those were the words that a flight attendant said to me as a boarded a plane to visit Paris for a summer vacation of wine and cheese.  It was a long flight; about 8 hours.  This particular plane was older and didn't have the personal TVs installed yet.  What this meant was I didn't have any movies to distract me from working on a pet project I had going on.  This little project was a single vim file in my vimrc.

<!--more-->

# That color thing

I was a huge fan of the original [vim-powerline][a] project.  Even though it was purely cosmetic and didn't really add value (compared other plugins like [vim-surround][c] where a productivity increase was measurable), I still considered it one of the most important plugins in my arsenal because I like things to look pretty.  I choose colorschemes with a lot of prejudice.  And I choose my font carefully as well (I'm currently using Ubuntu Mono as the preferred choice).  As developers we stare at a text editor the majority of our time, and if I can make that experience a little more enjoyable then that's a good enough reason for me!

# Prologue

If vim-powerline was already so good, why bother writing a replacement?  The biggest reason why I bothered was powerline [v2][m].  This was the python rewrite of powerline which unified the codebase so that it could be used outside of vim, such as in bash, zsh, and tmux.  And just like that, vim-powerline was deprecated.

I was one of the early adopters because I like to use bleeding edge software.  I compile my vim to the latest tip, my preferred Linux distribution is [ArchLinux][e] (a rolling release distribution), and all my browsers are beta (sometimes alpha).

Early versions of powerline were very buggy for me to the point where I couldn't use it and had to fall back to vim-powerline.  It also lost a lot of features in the process, like integration with third party plugins like ctrlp and tagbar.  And lastly, installation made it very difficult to get working consistently across all operating systems.  And even within an OS, you would run into problems, e.g. system python vs homebrew python on OSX, or python3 being the default on Arch.  Ironically, I found installing on Windows the easiest of them all.

I started looking for alternatives and found [smartusline][f], which is a simple statusline plugin which changes colors like powerline.  I used it for a while, but eventually I felt a strong yearning for a nicer looking statusline.  Honestly, I didn't have a good reason not to use vim-powerline other than the fact that it was "old".  But powerline v2 wasn't ready yet either.  And with that I had enough of an excuse to spend my hacking hours writing statuslines.

# :help statusline

The first working version I had was [65 lines][g] of code.  It was not configurable and everything was hardcoded, but it served my needs and worked pretty well.  Over time I tweaked it slowly, making small changes here and there, changing colors, and eventually using powerline font symbols.  And then I thought, wait a minute, maybe someone else might find this useful!  So on that airplane ride I decided to create a plugin out of it and share it with the community.

[vim-airline][s] was born.

I published a link to the [vim subreddit][h] and it was well received.  I got a boost to 100 stars on GitHub in a day.  Cool!  People like what I built!

# The first pull request

The first pull request was to fix a spelling mistake where I used sep**e**rator instead of sep**a**rator.  It was also the first time I saw the big green "Merge Pull Request" button on GitHub.  And let me tell you that entire process is nothing short of amazing.  It is so damn easy to collaborate I wish I had this at work.

And then issues started coming in; bugs and feature requests.  More pull requests were submitted, some to fix bugs, others to fix performance problems.  I had my little open source project going and it was so much fun!  And people were open to suggestions, code reviews, and just generally very receptive to discussion.  It was awesome!

I continued working on the plugin to add theming support, and once I finished I posted it to [HackerNews][i].

# A lesson in marketing

It sounds obvious now after the fact, but I didn't really realize what a big difference marketing makes.  Last year I made a relatively significant contribution to the WPF world -- I added [PowerShell to Snoop][n].  Snoop is a staple tool for any WPF developer, and for my work to be accepted and merged into the main product was really quite something.  After many retweets, my fork acquired a whopping 6 stars.  The reason?  My target audience was C# developers who did WPF, *and* who used PowerShell.  It was tiny market!

vim-airline is different.  The market is all terminal users, which is a **huge** market.  It didn't matter if you were doing sysadmin work scripting the shell or developing a website in JavaScript or deploying a distributed cluster using Ruby.  Somebody would be using vim, and furthormore, because airline was written in 100% VimScript it worked for everyone.

After I posted it to HackerNews, momentum ***really*** picked up and a flood of bugs and feature requests came in.  A lot of people also starting writing themes for it, which validated my claim that it was easy to do.  The project gained another 200-300 stars overnight.

# Murphy's Law

Last Tuesday night, vim-airline became the default in the [spf13][j] distribution, which is one of the most popular distributions out there.  On that same night, I [pushed][k] a change to improve the extendability of the plugin.  It was the last thing I did that night and I went to bed shortly after.  Everything that could go wrong, went wrong -- I woke up to a flurry of emails about it breaking in the most [catastrophic][o] [way][p] [possible][r].  I jumped from my bed to the computer in record time to revert that change.  After a lot of (manual) investigation, I narrowed it down to the exact [patch][l] (1058) in Vim that affected my code.  That's what I get for using bleeding edge software...

Since this incident I've been testing with Vim 7.2 prior to pushing any code changes to the core.

# Destination to be determined...

Popularity continued to grow, and as of now, after being live for only 2 weeks, the project has 772 stars, 36 forks, and 15 contributors.  6 themes have been contributed.

It's hard to describe the feeling I'm having -- I guess I'm just really thrilled to have so many people take interest in something I built.  I had no idea it would be this popular, and now I'm just trying to keep up with the issues.

The community aspect of open source is incredible.  I don't know where the project will go from here, but for the time being, I'm going to sit back, relax, and enjoy the flight.


[a]: https://github.com/Lokaltog/vim-powerline
[b]: https://github.com/bling/vim-airline
[c]: https://github.com/tpope/vim-surround
[d]: https://github.com/altercation/solarized
[e]: http://www.archlinux.org
[f]: https://github.com/molok/vim-smartusline
[g]: https://github.com/bling/dotvim/blob/c39021c45289d11e515bd08c1f4a976f7ba4352e/plugin/statusline.vim
[h]: http://www.reddit.com/r/vim/comments/1hfbfz/vimairline_a_lightweight_statusline_light_as_air/
[i]: https://news.ycombinator.com/item?id=6002518
[j]: http://vim.spf13.com/
[k]: https://github.com/bling/vim-airline/commit/c0427e435d2eb2170517438ddd4f0b5fa7a8b691
[l]: https://code.google.com/p/vim/source/detail?r=66e615ce7f61948a2a4a8615d703a42d56763490&name=v7-3-1058
[m]: https://github.com/Lokaltog/powerline
[n]: http://bling.github.io/blog/2012/07/01/snoopshell-marriage-of-snoop-wpf-and/
[o]: https://github.com/bling/vim-airline/issues/49
[p]: https://github.com/bling/vim-airline/issues/45
[r]: https://github.com/spf13/spf13-vim/issues/397
[s]: https://github.com/bling/vim-airline
