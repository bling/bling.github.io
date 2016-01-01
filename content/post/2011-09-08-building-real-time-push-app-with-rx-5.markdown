---
layout: post
title: "Building a Real-time Push App with Silverlight: Part 5"
slug: building-real-time-push-app-with-rx-5
date: 2011-09-08
comments: true
tags: [ coding, twitter ]
---
I planned on this post to be about UI, but I’m going to defer that until the next post.  I said from the start of this series that I would document about everything about building the application from scratch, including my struggles.

And with that I want to mention something that got me scratching my head one too many times.  It was with how I used LinqToTwitter.  Here is the source code which you can immediately copy/paste into a blank project to reproduce:

``` csharp
public partial class MainPage : UserControl
{
    private readonly TwitterContext _context = new TwitterContext();
    private readonly ViewModel _vm1, _vm2, _vm3;

    public MainPage()
    {
        InitializeComponent();
        _vm1 = new ViewModel(_context);
        _vm2 = new ViewModel(_context);
        _vm3 = new ViewModel(_context);
        _vm1.Callback += () => Debug.WriteLine("Callback of VM1: " + _vm1.LocalState);
        _vm2.Callback += () => Debug.WriteLine("Callback of VM2: " + _vm2.LocalState);
        _vm3.Callback += () => Debug.WriteLine("Callback of VM3: " + _vm3.LocalState);

        _vm1.Start();
        _vm2.Start();
        _vm3.Start();
    }
}

public class ViewModel
{
    private readonly TwitterContext _context;
    public event Action Callback;

    public int LocalState;

    public ViewModel(TwitterContext context)
    {
        _context = context;
    }

    public void Start()
    {
        var query = (from s in _context.Status
                where s.Type == StatusType.Public && s.Count == 10
                select s);
        Debug.WriteLine("Hash code of ViewModel: " + query.GetHashCode());
        query.AsyncCallback(statuses =>
                {
                LocalState++;
                Debug.WriteLine("Hash code inside callback: " + GetHashCode());
                Callback();
                }).FirstOrDefault();
    }
}
```

Now, if you run this, you will see that only *one* of the view models will get its state updated.  Huh?!

How is that possible?  I started getting paranoid so I even added the local state variable “just in case.”

Well, I had to look into the source code of LinqToTwitter to figure out exactly what happened.  Here is the code for AsyncCallback:

``` csharp
public static IQueryable<T> AsyncCallback<T>(this IQueryable<T> queryType, Action<IEnumerable<T>> callback)
 {
     (queryType.Provider as TwitterQueryProvider)
         .Context
         .TwitterExecutor
         .AsyncCallback = callback;

     return queryType;
 }
```

See what happened?  The callback gets overwritten every time you call this method.  Even though the call to `FirstOrDefault`() causes all 3 expressions to evaluate, only the last view model will get values because that’s the with the callback attached.

Lesson of the day: The AsyncCallback extension method for LinqToTwitter is not thread-safe.

So...the question is, how do we make it thread safe?  I just replaced wrapped the AsyncCallback with another extension method:

``` csharp
private static readonly AutoResetEvent _twitterEvt = new AutoResetEvent(true);
 
public static void AsyncTwitterCallback<T>(this IQueryable<T> twitter, Action<IEnumerable<T>> callback)
{
    Observable.Start(() =>
    {
        _twitterEvt.WaitOne();
        twitter.AsyncCallback(results =>
        {
            try
            {
                callback(results);
            }
            finally
            {
                _twitterEvt.Set();
            }
        }).FirstOrDefault();
    });
}
```

Nothing complicated – just a simple wait handle to ensure only 1 thread can go through at a time.

Hopefully upstream fixes this, or at least documents it.
