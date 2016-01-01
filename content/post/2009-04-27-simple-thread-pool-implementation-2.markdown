---
layout: post
title: "A Simple Thread Pool Implementation (Part 2)"
slug: simple-thread-pool-implementation-2
date: 2009-04-27
comments: false
tags: [ 'coding' ]
---
I said last time I'd compare the performance of my super duper simple implementation against the .NET ThreadPool, so here it is!

Here's the test code:
``` csharp
ManualResetEvent evt = new ManualResetEvent(false);
int total = 100000;
int count = 0;
DateTime start = DateTime.Now;
for (int i = 0; i < total; ++i)
{
//  ThreadQueue.QueueUserWorkItem(delegate(object obj)
    ThreadPool.QueueUserWorkItem(delegate(object obj)
    {
        Console.WriteLine(obj);
        if (Interlocked.Increment(ref count) == total)
            evt.Set();
    }, i);
}
evt.WaitOne();

Console.WriteLine("Time: {0}ms", (DateTime.Now - start).TotalMilliseconds);
Console.ReadLine();
```
Here are the initial tests.  My CPU is a Core2Duo clocked at 3.6GHz.  I also ran a release build outside of the debugger.  I set my ThreadQueue to have 25 worker threads.  The results were pretty surprising:
- ThreadPool: 1515.6444ms
- ThreadQueue: 5093.8152ms

Well, that's interesting.  The .NET ThreadPool whooped my butt!  How can that be?  Let's dig deeper and find out how many threads actually got used.  I used `ThreadPool.GetMinThreads` and `ThreadPool.GetMaxThreads`, and I got 2-500 for worker threads, and 2-1000 for completion IO threads.

Then, I tracked how many threads were actually used, like this:
``` csharp
Dictionary<int, int> threads = new Dictionary<int, int>();
// ...snip
    ThreadPool.QueueUserWorkItem(delegate(object obj)
    {
        Console.WriteLine(obj);
        threads[Thread.CurrentThread.ManagedThreadId] = 0;
        if (Interlocked.Increment(ref count) == total)
            evt.Set();
    }, i);
// ...snip
Console.WriteLine("Threads used: {0}", threads.Count);
```
Surprisingly, only 2 threads were used.  So, I set the number of worker threads of my ThreadQueue to 2.  Viola!  1437.5184ms, which is just a little under 100ms faster than the ThreadPool.

*I guess this shows that more threads does not mean better or faster!*

For fun I set the number of worker threads to 200 and it took 27906.6072ms!  There was clearly a lot of locking overhead here...
