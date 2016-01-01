---
layout: post
title: "A Simple Thread Pool Implementation"
slug: simple-thread-pool-implementation-1
date: 2009-04-27
comments: false
tags: coding
---
I've always wanted to do this, and finally I've gotten around to doing it.  Here's a super duper simple implementation of a working thread pool.  I named in ThreadQueue just so it's clearly discernible from the one provided by the framework.
``` csharp
public static class ThreadQueue
{
    static Queue<WorkItem> _queue = new Queue<WorkItem>();

    struct WorkItem
    {
        public WaitCallback Worker;
        public object State;
    }

    static ThreadQueue()
    {
        for (int i = 0; i < 25; ++i)
        {
            Thread t = new Thread(ThreadWorker);
            t.IsBackground = true;
            t.Start();
        }
    }

    static void ThreadWorker()
    {
        while (true)
        {
            WorkItem wi;
            lock (_queue)
            {
                while (_queue.Count == 0)
                {
                    Monitor.Wait(_queue);
                }
                wi = _queue.Dequeue();
            }
            wi.Worker(wi.State);
        }
    }

    public static void QueueUserWorkItem(WaitCallback callBack, object state)
    {
        WorkItem wi = new WorkItem();
        wi.Worker = callBack;
        wi.State = state;
        lock (_queue)
        {
            _queue.Enqueue(wi);
            Monitor.Pulse(_queue);
        }
    }
}
```
As you can see, it's very short and very simple.  Basically, if it's not used, no threads are started, so in a sense it is lazy.  When you use it for the first time, the static initializer will start up 25 threads, and put them all into waiting state (because the queue will initially be empty).  When something needs to be done, it is added to the queue, and then it pulses a waiting thread to perform some work.

And just to warn you, if the worker delegate throws an exception it will crash the pool....so if you want to avoid that you will need to wrap the wi.Worker(wi.State) with a try/catch.

I guess at this point you may wonder why one should even bother writing a thread pool.  For one, it's a great exercise and will probably strengthen your understanding of how to write multithreaded applications.  The above thread pool is probably one of the simplest use-cases for Monitor.Pulse and Monitor.Wait, which are crucial for writing high-performance threaded applications.

Another reason is that the .NET ThreadPool is optimized for many quick ending tasks.  All asynchronous operations are done with the ThreadPool (think BeginInvoke, EndInvoke, BeginRead, EndRead, etc.).  It is not well-suited for any operation that takes a long time to complete.  MSDN recommends that you use a full-blown thread to do that.  Unfortunately, there's a relatively big cost of creating threads, which is why we have thread pools in the first place!  Hence, to solve this problem, we can write our own thread pool which contains some alive and waiting threads to performing longer operations, without clogging the .NET ThreadPool.

In my next post I'll compare the above implementation's performance against the built-in ThreadPool.
