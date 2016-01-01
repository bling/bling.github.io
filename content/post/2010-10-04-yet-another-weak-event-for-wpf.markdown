---
layout: post
title: "Yet Another Weak Event Implementation"
slug: yet-another-weak-event-for-wpf
date: 2010-10-04
comments: false
categories: coding
---

I gotta say that WPF is a complete pain in the butt when it comes to memory leaks.  A simple google/bing search shows up more than enough results for weak events, so why am I making yet another blog post about another implementation of a weak event?  Well, if someone else out there happens to have the same requirements/needs that I do right now, maybe this will save them a little time.

In my particular case, I needed to accomplish a couple goals:
- Minimal performance hit.  a.k.a minimal use of reflection.
- Generic and easy to use.
- Thread safe.
- Support for explicit registration and unregistration.

One of the better implementations on weak events I found was from Dustin Campbell's [blog post](http://diditwith.net/PermaLink,guid,aacdb8ae-7baa-4423-a953-c18c1c7940ab.aspx).  Unfortunately, this implementation has one major problem: you cannot explicitly unregister.  In fact, the only way an attached listener no longer receives messages is if it gets garbage collected.  Our application happened to use this for an especially special event on our base entity: the infamous INotifyPropertyChanged event.  Needless to say, all the static WPF dependency objects left a whole bunch of leaked WeakReferences around (ironic?).

But wait, doesn't WPF already have a IWeakEventManager that solves this problem?  The problem with this is a couple things.  It's slow.  It's painful to use.  It's annoying to implement.  Long story short, you need a static WeakEventManager for *every* unique delegate.  Yes, sure, you can override a lot of the methods to make it more perform faster, but if you need to go that far you might as well write your own that does just what you need, and no more.

If you haven't found it already, Daniel Grunwald's Code Project [article](http://www.codeproject.com/KB/cs/WeakEvents.aspx) is yet another great resource.  My implementation was a mix of this and the earlier mentioned link.  Anywho, here it is:
``` csharp
public interface IWeakEventEntry<TSender, TArgs>
{
    bool IsAlive { get; }
    bool Matches(Delegate handler);
    bool Invoke(SynchronizationPriority priority, TSender sender, TArgs args);
}
public class WeakEventEntry<TTarget, TSource, TArgs> : IWeakEventEntry<TSource, TArgs> where TTarget : class
{
    private delegate void OpenForwardingEventHandler(TTarget target, TSource sender, TArgs args);
    private readonly WeakReference m_TargetRef;
    private readonly OpenForwardingEventHandler m_OpenHandler;
    private readonly MethodInfo m_Method;
    public WeakEventEntry(Delegate handler)
    {
        m_OpenHandler = (OpenForwardingEventHandler)Delegate.CreateDelegate(typeof(OpenForwardingEventHandler), null, handler.Method);
        m_TargetRef = new WeakReference(handler.Target);
        m_Method = handler.Method;
    }
    public bool IsAlive { get { return m_TargetRef.IsAlive; } }
    public bool Matches(Delegate handler)
    {
        return handler.Method == m_Method && handler.Target == m_TargetRef.Target;
    }
    public bool Invoke(TSource sender, TArgs args)
    {
        TTarget target = m_TargetRef.Target as TTarget;
        if (target != null)
        {
            m_OpenHandler(target, sender, args);
            return true;
        }
        return false;
    }
}
public class WeakEvent<TSender, TArgs>
{
    private static readonly IWeakEventEntry<TSender, TArgs>[] EMPTY_LIST = new IWeakEventEntry<TSender, TArgs>[0];
    private List<IWeakEventEntry<TSender, TArgs>> m_Events;
    private IWeakEventEntry<TSender, TArgs>[] m_InvokeList = EMPTY_LIST;
    public int Count { get { return m_InvokeList.Length; } }
    public void Add(Delegate handler)
    {
        if (handler.Target == null) // static method
        {
            Add(new StrongEventEntry<TSender, TArgs>(handler));
        }
        else
        {
            Type type = typeof(WeakEventEntry<,,>).MakeGenericType(handler.Target.GetType(), typeof(TSender), typeof(TArgs));
            Add((IWeakEventEntry<TSender, TArgs>)type.GetConstructors()[0].Invoke(new object[] { handler }));
        }
    }
    public void Add(IWeakEventEntry<TSender, TArgs> entry)
    {
        lock (this)
        {
            if (m_Events == null)
                m_Events = new List<IWeakEventEntry<TSender, TArgs>>(8);
            m_Events.Add(entry);
            m_InvokeList = m_Events.ToArray();
        }
    }
    public void Remove(Delegate handler)
    {
        lock (this)
        {
            if (m_Events != null)
            {
                for (int i = 0; i < m_Events.Count; i++)
                {
                    if (m_Events[i].Matches(handler))
                    {
                        m_Events.RemoveAt(i);
                        break;
                    }
                }
                m_InvokeList = m_Events.ToArray();
            }
        }
    }
    public void Clear()
    {
        lock (this)
        {
            m_Events = null;
            m_InvokeList = EMPTY_LIST;
        }
    }
    public void Raise(TSender sender, TArgs args)
    {
        IWeakEventEntry<TSender, TArgs>[] events = m_InvokeList;
        bool removeDead = false;
        for (int i = events.Length - 1; i >= 0; i--)
            removeDead |= !events[i].Invoke(sender, args);
        if (removeDead)
            RemoveDeadReferences();
    }
    private void RemoveDeadReferences()
    {
        lock (this)
        {
            if (m_Events != null)
            {
                for (int i = m_Events.Count - 1; i >= 0; i--)
                {
                    if (!m_Events[i].IsAlive)
                        m_Events.RemoveAt(i);
                }
                m_InvokeList = m_Events.ToArray();
            }
        }
    }
}
```
Nothing too special here.  For performance, a copy of all events are stored in an array so that raising events doesn't need to be in a lock.  And while locking on "this" is usually bad practice, in this case I didn't have any other local variable to use, and creating an object just for the sake of locking in my eyes was not worth it in this scenario.

I tried generating the OpenForwardingDelegate using DynamicMethod and IL, but the result was negligible because it doesn't actually affect invoking speed, which is what we're most concerned with.

Also, if you didn't notice, this implementation also supports static methods attaching, hence why there is an IWeakEventEntry interface.  Here's the StrongEventEntry implementation:
``` csharp
public class StrongEventEntry<TSource, TArgs> : IWeakEventEntry<TSource, TArgs>
{
    private delegate void ClosedForwardingEventHandler(TSource sender, TArgs args);
    private readonly ClosedForwardingEventHandler m_ClosedHandler;
    private readonly MethodInfo m_Method;
    public bool IsAlive { get { return true; } }
    public StrongEventEntry(Delegate handler)
    {
        m_Method = handler.Method;
        m_ClosedHandler = (ClosedForwardingEventHandler)Delegate.CreateDelegate(typeof(ClosedForwardingEventHandler), null, handler.Method);
    }
    public bool Matches(Delegate handler)
    {
        return m_Method == handler.Method;
    }
    public bool Invoke(SynchronizationPriority priority, TSource sender, TArgs args)
    {
        m_ClosedHandler(sender, args);
        return true;
    }
}
```
Last but not least, usage:
``` csharp
private WeakEvent<object, PropertyChangedEventArgs> _propertyChanged = new WeakEvent<object, PropertyChangedEventArgs>();
public event PropertyChangedEventHandler PropertyChanged
{
    add { _propertyChanged.Add(value); }
    remove { _propertyChanged.Remove(value); }
}
```
Performance is quite good.  On my machine for 1,000,000,000 invocations, it takes the WeakEvent ~17.3 seconds, vs 4.2 seconds for a standard delegate, for roughly 4x invocation cost.

And there you have it!  A simple, generic, and fast weak event in ~200 lines of code.
