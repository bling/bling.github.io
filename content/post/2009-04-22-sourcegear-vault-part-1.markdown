---
layout: post
title: "SourceGear Vault, Part 1"
date: 2009-04-22
comments: false
tags: [ 'scm' ]
---
I'll be starting a new job soon, and the company is using SourceGear Vault, so I went ahead and downloaded the latest beta versions off the site (since it's free for single users) to see how it was like.

I've hated SourceSafe from the first time I used it.  The nail in the coffin was when my data got corrupted and some of my work was lost.  At the very least, no source control management system should **ever** lose any work.  Unfortunately, my current workplace is still using SourceSafe and I was unable to convince them otherwise.  I've coped with the situation by using Mercurial for a quick local repository, and checking in changes back to VSS for major changesets.  The choice to go with hg instead of git or bzr was mainly because I'm a Windows developer and hg is currently way ahead of the other two on Windows.

Anyways, since Vault is frequently advertised as SourceSafe done right, I was curious to how it would affect my opinion of how things "should" have worked.

I'm a long term user of Subversion, and most of my experience of actually using SCM is with svn.  I used hg at work just to see what all this DVCS hype is all about.

With that in mind, setting up Vault was certainly more eventful then I expected, since it involved setting up SQL Server and IIS.  After all the requirements were taken care of (the most time consuming part), installing Vault was pretty quick.

The administration interface is simple and straightforward, and had a repository created by default.

Then, the real fun began!  Tune back for part 2!
