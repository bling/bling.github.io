+++
tags = ['blogging']
date = "2015-12-31T22:55:37-05:00"
title = "Migrating from Jekyll/Octopress to Hugo"
slug = "migrating-from-jekyll-octopress-to-hugo"
+++

Migrating my blog from [Octopress][1] to [Hugo][2] has been on my TODO list for a very long time.  In fact, the only reason holding me back was lack of pagination support, but that has been implemented for a while now, so I finally got around to migrating my blog over.

# Getting started

Since this is an entirely new generator, it made sense to start from scratch.  So I created an empty site, copied all the markdown files over, and voila, new blog!  But of course, it wasn't all smooth sailing, and I needed to resolve some issues.

<!--more-->

# Permalinks

First problem was all the permalinks that Octopress generated did not match the default value for Hugo.  This was easily resolved with a `[permalinks]` section in the `config.toml`.

# Title != title

This was most troubling, and resulted in a lot of manual labor to fix.  The problem was that Octopress (or Jekyll), would generate a URL from the title, but would omit things like "the", or "a".  For example, the very first post of my blog is titled [The Importance of Color Schemes][3], but the URL is actually `/importance-of-color-schemes`.

Luckily, you can define a `slug` parameter in the front matter which can override this.  Suffice to say, I had to do this for a lot of posts.

In most migrations you don't have to worry about keeping the same URLs, but in my case I needed them to be the same because that's how [Disqus][4] tracks discussions, and I wanted all the existing conversations to remain intact.

# Code fences

Jekyll supports doing syntax highlighting with code fences, e.g.:

<pre>
``` javascript
alert('Hello World'!);
```
</pre>

Support for this can be done via Pygments, with is off by default.  If you add `pygmentscodefences = true` to your `config.toml` then these sections will be parsed correctly.  You'll also want to use `pygmentsuseclasses = true` so that you can style it appropriately.

# Markdown references

This last one was a bit of an annoyance because I needed to download the source of Hugo and make code modifications.  Specifically, this [pull request][6] was needed.

Long story short, if you use references for links, instead of inline, then summaries will not work.

# And the rest

Once all the heavily lifting was done, now it was a matter of picking a theme and modifying it to my liking.  I ended up using [herring cove][5].  I really liked how Hugo separates the content from the theme, making it relatively easy to switch back and forth.

# And the benefits?

Holy crap this is too fast!

[1]: https://github.com/octopress/octopress
[2]: https://github.com/spf13/hugo
[3]: http://bling.github.io/blog/2008/09/11/importance-of-color-schemes/
[4]: http://www.disqus.com
[5]: https://github.com/bling/herring-cove
[6]: https://github.com/spf13/hugo/pull/1667
