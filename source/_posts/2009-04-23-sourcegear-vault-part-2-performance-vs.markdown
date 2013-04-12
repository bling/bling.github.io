---
layout: post
title: "SourceGear Vault, Part 2 (Performance vs Subversion)"
date: 2009-04-23
comments: false
categories: source control management
---
Obviously you can't compare something without performance numbers!  So in this post I'll post some performance numbers for the most common operations.  I'll be using the Linux kernel for no reason other than it's readily available and everyone knows about it.  The size of the code base is also relatively large (depending on who you ask).

In general, I "felt" that Vault is slower than Subversion.  This is probably due to the .NET runtime startup time for most operations, which is negligible for anything but trivial operations.

Test environment:
- Core2Duo clocked at 3.6GHz
- 4G of RAM
- Vista 64bit/IIS7/SQL2008Express
- Vault 5.0 Beta 1 (I'm hoping the beta isn't going to affect performance numbers drastically)
- TortoiseSVN 1.6.1
- Linux kernel 2.7.29 (roughly 300MB of source code and more than 26000 files)

Both server and client are on the same computer, so none of these scenarios will really test network performance.

Anyway, on with the tests.

Time it took to recursively add all folders and files and just bring up confirmation dialog
- Vault:  ~14s
- Subversion: ~11s

Time it took to mark all files to add (create a changeset):
- Vault:  0s (it was pretty much instant)
- Subversion:  ~6m52s

Time it took to commit:
- Vault: ~21m10s
- Subversion: ~28m50s

Total:
- Vault:  ~28m16s
- Subversion:  ~35m53s

As you can see, Vault was slightly slower at a trivial operation like which files to add, but once it got to some real work to do, it ended up being faster overall vs Subversion.  A significant part of the Subversion time was devoted to creating .svn folders.

After this, it was apparent that Subversion has a pretty major advantage over Vault...working offline.  Vault does not appear to keep any offline information.  This was confirmed when I went into offline mode in Visual Studio and pretty much all functionality was disabled except for "go online."  Basically, when you're working offline in Vault you can no longer diff with the original version, no reverting changes, no anything.  Once you go online it scans your working copy for any changes and the "pending changes" will update.

I don't like super long posts, so there will most definitely be a part 3 where I'll continue on with some common operations.
