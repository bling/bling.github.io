---
layout: post
title: Who woulda thought, IList<> kills WCF
date: 2009-08-06
comments: false
tags: [ 'coding' ]
---
It can't be that hard!!!

I keep telling myself this.  I'm writing a WCF application right now and I've been running into loads of problems trying to configure things.  ABC right?  Set my address, contract, and binding....how hard can it be??  Why is a horrible ExecutionEngineException being thrown and taking down IIS with it???

<http://connect.microsoft.com/wcf/feedback/ViewFeedback.aspx?FeedbackID=433569>

Turns out you can't have an IList<> of DataContracts.
