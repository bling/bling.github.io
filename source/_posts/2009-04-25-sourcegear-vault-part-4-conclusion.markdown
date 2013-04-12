---
layout: post
title: "SourceGear Vault, Part 4, Conclusion"
date: 2009-04-25
comments: false
categories: source control management
---
I suppose I should give a disclaimer since I am *not* an expert with Vault, and my opinions may be completely due to my lack of understanding of the system.  With that in mind, here's what my experience of using Vault has been so far.

In general, it is not as fast as TortoiseSVN.  There are many operations in SVN that are instant, where the comparable operation in Vault is met with 10 seconds of "beginning transaction" and "ending transaction", sometimes more.

Feature-wise, Vault has much more to offer than Subversion does.  Basically, it can do most of what Subversion can do, plus features from SourceSafe (like sharing, pinning, labeling, etc.).  However, like I mentioned before, Vault has no offline support whatsoever, and you cannot generate patches, so it effectively cuts off any kind of outside collaboration.

You could say that this is fine because SourceGear's target audience is small organizations where everyone will have access to the network anyway, but that doesn't mean that you won't be sent off to the middle of nowhere with no internet access and you need to fix bugs now!  Not to say that Subversion is much better in that scenario, but at least you can still revert back to the last updated version.
