---
layout: post
title: "Building a Real-time Push App with Silverlight: Part 4"
slug: building-real-time-push-app-with-rx-4
date: 2011-09-05
comments: true
categories: [ coding, rx, twitter ]
---
Originally I wanted to avoid bringing in external libraries to keep the app as lean as possible, but then I realized that I would spend too much time reinventing the wheel.  Twitter is deprecating basic authentication in the near future, which makes OAuth no longer optional.  Rather than writing yet another Twitter client (if you’re curious I found a great reference [here](http://chris.59north.com/post/2009/09/16/SilverTweet-e28093-Building-a-Silverlight-Twitter-client-part-1.aspx)), I fired up [NuGet](http://nuget.org/) and brought in [LinqToTwitter](http://linqtotwitter.codeplex.com/), and while I’m there I brought in [Autofac](http://code.google.com/p/autofac/) and [Caliburn.Micro](http://caliburnmicro.codeplex.com/) as well.

Naturally, LinqToTwitter will work nicely with Rx because as name implies it uses LINQ heavily.  Caliburn.Micro is a MVVM library which I’ve always wanted an excuse to try because of features like this:

``` xml
<ListBox cal:Message.Attach="[Event Loaded] = [LoadList($dataContext)]" />
```

That’s only scratching the surface of what Caliburn can do, so it will be a fresh breath of air to see what else it can do.

By default, Caliburn uses MEF to wire up its bootstrapper.  After adding a couple `[Import]`s and `[Export]`s, I knew it wasn’t for me.  It works well for writing plugins, i.e. *external* dependencies because of its built-in assembly scanning capabilities, but for injecting *internal* dependencies, other IoC containers do a much better job of that.  I used Castle Windsor in past projects, but for a change I’m going to use Autofac which I haven’t used since v2 came out.

When this was all said and done the View was the only thing that didn’t change.  Everything underneath either changed radically or was deleted altogether (because LinqToTwitter provided it).  I added OAuth support and registered my application with Twitter, and with that was the birth of Ping Pong.

This took much longer than expected.  Silverlight 5 RC just came out and it broke pretty much any container (including MEF) for OOB because of a TypeLoadException.  I haven’t been using too many v5 features, so for the time being I downgraded to v4 to get the project working until RC2 comes out.

Integrating LinqToTwitter was a challenge.  The project site has a lot of good documentation, but most of it was for desktop, not Silverlight, and because of that I banged my head a couple times.  I wish I grabbed the source code earlier because it’s there where you’ll find hundreds of working examples (in code!) to do everything with the library (and in Silverlight).

After all that, PingPong now has 3 columns (home, public, sampling) that *dynamically resizes* (it’s surprising that [MetroTwit](http://metrotwit.com) is the only client that does this...) to the window size.

![img](http://lh4.ggpht.com/-f1uQ63FwyoI/TmU-fK3WfQI/AAAAAAAAAGc/Y26EvwnXy_4/image_thumb%25255B15%25255D.png?imgmax=800)

Oh, and there’s pictures now!  The streaming time line takes significantly more CPU now that it has to load images, but we’re still sitting at around 5-10% for what is continuously streaming data and loading pictures.  Not too shabby!  (It took a couple tries to get a PG-13 screenshot from the public/streaming time lines...)

To conclude this post in the series, I’m going to talk about converting an asynchronous operation into an Observable that does not follow any predefined pattern.

# Creating an Observable

One of Silverlight’s limitations is that almost everything needs to be an asynchronous call.  In regards to LinqToTwitter, something like this will fail (but work on desktop):

``` csharp
var tweets = (from t in context.Status
              where t.Type == StatusType.Public
              select t).ToArray();
```

On Silverlight you will get a single empty element.  To get it working, there is an extension method that comes with the library, and you use it like this:

``` csharp
(from t in context.Status
 where t.Type == StatusType.Public
  select t)
  .AsyncCallback(tweets => { /* do something with it */ })
  .FirstOrDefault();
```

Code is self-explanatory.  The `FirstOrDefault()` exists only to initiate the expression, otherwise it wouldn’t do anything.  So now the question is how do we convert that into an Rx Observable?

Every time I write an Rx query I try to use the least amount of state as possible.  This helps to keep the number unexpected anomalies to a minimum.  In the following section of code, I was able to get it down to 2 fields: `_sinceId`, and `Context`.  There is probably some operator that will let me save the sinceId variable from one observable to the next but I wasn’t able to figure it out.  In any case, I came up with this:

``` csharp
_subscription =
    Observable.Create<Tweet>(
        ob => Observable.Interval(TimeSpan.FromSeconds(60))
            .StartWith(-1)
            .SubscribeOnThreadPool()
            .Subscribe(_ =>
            {
                ulong sinceId;
                (ulong.TryParse(_sinceId, out sinceId)
                    ? Context.Status.Where(s => s.Type == statusType && s.Count == 200)
                    : Context.Status.Where(s => s.Type == statusType && s.Count == 200 && s.SinceID == sinceId))
                .AsyncCallback(statuses =>
                {
                    foreach (var status in statuses)
                    {
                        ob.OnNext(new Tweet(status));
                        _sinceId = status.StatusID;
                    }
                })
                .FirstOrDefault(); // materalize the results
            }))
    .DispatcherSubscribe(SubscribeToTweet);
```

That contains some custom code:

* Context:  is a TwitterContext from LinqToTwitter 
* DispatcherSubscribe:  is a helper extension method which Subscribes on the ThreadPool, Observes on the Dispatcher, and then Subscribes with the specified action 
* SubscribeToTweet: a method in the base class which adds to a ObservableCollection so the UI gets updated

To translate the code, here is a basic flow of what’s happening:

1. Observable.Create wraps the subscription of another Observable.  It provides access to an IObserver `ob` which lets you explicitly invoke OnNext().
2. Observable.Interval will raise an observable every 60 seconds.
3. The subscription of Observable.Interval will query the TwitterContext for the next set of tweets.
4. Inside the AsyncCallback, it invokes `ob.OnNext `as well as keeps track of the ID so the next time it queries it only gets newer tweets.
5. Finally, `DispatcherSubscribe` will take the `Tweet` object and add it to an `ObservableCollection<Tweet>`, which notifies the UI.

As always, you should “clean up your garbage”.  In this respect I was pretty impressed with Rx as it was able to clean up the entire chain of observables with a single call to `_subscription.Dispose()`.  Nice!

In the next post I’m going to switch back to UI and completely restyle the application.  The code will hit GitHub soon as well (I promise!).  Stay tuned...

<h2>Comments</h2>
<div class='comments'>
<div class='comment'>
<div class='author'>bling</div>
<div class='content'>
Looks like the same StartWith() trick is needed for Observable.Generate.<br /><br />I played around with Observable.Generate and all the expressions I came up looked pretty complicated in comparison with what I originally had.  This is mainly because I need to call OnNext() inside the AsyncCallback, so all solutions either had external Subjects or obscure ways of passing an IObserver around...<br /><br />Maybe I&#39;m overcomplicating things so if you can come up with an example it&#39;d be greatly appreciated.  I&#39;m still a Rx newbie...<br /><br />Thanks!</div>
</div>
<div class='comment'>
<div class='author'>bling</div>
<div class='content'>
Thanks!  I didn&#39;t know about that overload.<br /><br />Is there a way to make it start immediately, like the StartWith(-1) in the original expression?<br /><br />Observable.Generate(<br />   0, <br />   _ =&gt; true,<br />   _ =&gt; _,<br />   _ =&gt;<br />   {<br />     // this doesn&#39;t get called until 60 seconds passes first...<br />     return 0;<br />   }, <br />   _ =&gt; TimeSpan.FromSeconds(60));</div>
</div>
<div class='comment'>
<div class='author'>jwooley</div>
<div class='content'>
Rather than the custom Observable generator with Iterval, why not use Observable.Generate passing in a timespan of 60 seconds?</div>
</div>
</div>
