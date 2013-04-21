---
layout: post
title: "Memory Leak with WPF’s RichTextBox"
date: 2010-10-05
comments: true
---

Apparently, setting `IsUndoEnabled` to false isn’t enough.  You must also set `UndoLimit=0` as well otherwise it'll still keep track of undo history.  Doh!
