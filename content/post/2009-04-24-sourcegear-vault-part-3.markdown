---
layout: post
title: "SourceGear Vault, Part 3 (Performance vs Subversion)"
slug: sourcegear-vault-part-3
date: 2009-04-24
comments: false
categories: source control management
---
I downloaded the kernel 2.6.29.1, and extracted it to the working folder.  I figured this was an easy way to have a real-world scenario of changes (albeit a little big since it is all changes that happened between 29 and 29.1).

Anywho, I was pretty surprised to find out that Vault does not have any feature whatsoever to allow collaboration between programmers other than via the client.  You cannot create a .patch file and email it to someone.  Everyone is assumed to have access to the server.

This thwarted my plans to test the performance of diffing the changeset, because I simply planned on comparing how long it would take to create the patch.

Ah well, I guess I'll just have to compare the performance of committing the changes between 29 and 29.1, which is a common use case as well so I don't mind.

Time it took to a) start up the Vault client, b) bring up the Vault commit dialog, or c) bring up to TortoiseSVN commit dialog:
- Vault startup: ~1m02s
- Vault commit: ~7m55s
- Subversion commit: ~4m33s

Time it took to commit:
- Vault: ~13m45s, and at 14m34s the HD stopped spinning
- Subversion: ~1m42s

Hmmmmm, it doesn't look like Vault did too well in this comparison.  Getting a status of all changed files took almost twice as long compared with Subversion, and what's worse, committing with Valut took 12 minutes longer than it did with Subversion.  The extra minute with the hard drive spinning was attributed to SQL Server completing the transaction, which is why I separated that part, because as far as the client was concerned the operation was complete after 13m45s.

One more quick test...branching.  Subversion is famous for its O(1) time to branch anything, from the smallest to the biggest.  SourceGear's page of [Vault vs Subversion](http://sourcegear.com/vault/vs/subversion/) mentions that both offer cheap branches.  Let's see that in action!

I used TortoiseSVN's repo-browser and branched the kernel.  It was practically instant with no wait time for the operation to finish.  Vault, on the other hand, took a total of 47 seconds from the time it took me to commit the branch, to when the status said "ready" again.
