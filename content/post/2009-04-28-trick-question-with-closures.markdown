---
layout: post
title: "A Trick Question With Closures"
slug: trick-question-with-closures
date: 2009-04-28
comments: false
categories: coding
---
Given the following code, what do you expect the output to be?
``` csharp
for (int i = 0; i < 100; ++i)
{
    ThreadPool.QueueUserWorkItem(delegate
    {
        Console.WriteLine(i);
    });
}
```
Keep that answer in your head!  Now...what do you expect the output of the following?
``` csharp
int i;
for (i = 0; i < 100; ++i)
{
    ThreadPool.QueueUserWorkItem(delegate
    {
        Console.WriteLine(i);
    });
}
```
Were your answers the same?  Different?  Why?
