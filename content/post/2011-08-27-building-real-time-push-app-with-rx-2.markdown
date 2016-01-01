---
layout: post
title: "Building a Real-time Push App with Silverlight: Part 2"
slug: building-real-time-push-app-with-rx-2
date: 2011-08-27
comments: true
tags: [ 'rx', 'coding' ]
---
Let’s review the main Rx code from last time:

``` csharp
public IObservable<string> GetJsonStreams()
{
    var request = GetRequest();
    return Observable.FromAsyncPattern<WebResponse>(request.BeginGetResponse, request.EndGetResponse)()
        .Select(wr => wr.GetResponseStream())
        .Select(str => Observable.FromAsyncPattern<byte[], int, int, int>(str.BeginRead, str.EndRead))
        .SelectMany(ParseJson);
}
```
One thing I didn’t like about this was that the web request object was created regardless of whether the Observable gets a subscription or not.  This is potentially wasted resources, and I wanted to refactor this to be completely lazy.

And with this I started to run into my first "huh?" moments with Rx: I blocked the UI thread.  How did I do that? I started down the path of exploring some more of the Rx methods, which lead me to `Create`, which lets you manually call `OnNext`.  With this train of thought, I came up with something like this:
``` csharp
return Observable.Create<string>(obs =>
    {
        var request = GetRequest();
        var response = Observable.FromAsyncPattern<WebResponse>(request.BeginGetResponse, request.EndGetResponse)().First();
        var str = response.GetResponseStream();
        var reader = Observable.FromAsyncPattern<byte[], int, int, int>(str.BeginRead, str.EndRead);
        foreach (var json in ParseJson(reader))
        obs.OnNext(json);

        obs.OnCompleted();
        return str;
    });
```
Great! The initialization of the web request only occurs when subscribed! And it will even dispose the stream (by returning `str`) upon unsubscription.  I ran the app and the UI thread immediately blocked.  What happened?

Rx has the concept of subscription and observation, and provides a way to subscribe and observe on different threads.  Here is the original code that subscribed:

``` csharp
s.GetJsonStreams()
   .ObserveOnDispatcher()
   .Subscribe(x => Text = x);
```
Can you spot the error? I explicitly told Rx to observe on the dispatcher thread, because I want the action inside `Subscribe` to be invoked on the UI thread, but I didn’t specify where I want to set up the subscription.  Since I left it out, it uses the current thread, which happens to be the UI thread.  To solve this, it’s as simple as doing this:

``` csharp
s.GetJsonStreams()
    .SubscribeOn(Scheduler.ThreadPool)
    .ObserveOnDispatcher()
    .Subscribe(x => Text = x);
```
That’s it! Easy! This also follows one of the most important guidelines when using Rx: *Subscription and Observation should be done as late as possible*, typically just before the `Subscribe`.  Anything more and you’ll likely make Rx spawn more threads than are necessary or some other nasty bugs.  [KISS](http://en.wikipedia.org/wiki/KISS_principle)!

Now with that out of the way, let’s replace the boring TextBlock with something more usable.  First, I need to parse all the JSON streams I’m getting into bindable models.  To do that, I upgraded my StreamReader component and threw in System.Json for some basic parsing:

``` csharp
public class TweetParser
{
    private int _stack;
    private readonly StringBuilder _sb = new StringBuilder();

    public IEnumerable<Tweet> Parse(byte[] buffer, int count)
    {
        for (int i = 0; i < count; i++)
        {
            var current = (char)buffer[i];
            _sb.Append(current);

            if (current == '{') _stack++;
            else if (current == '}') _stack--;

            if (_stack == 0 &_sb.Length > 0)
            {
                Tweet tweet;
                var value = JsonValue.Parse(_sb.ToString());

                if (value is JsonObject &Tweet.TryParse((JsonObject)value, out tweet))
                    yield return tweet;

                _sb.Clear();
            }
        }
    }
}
```

Nothing overly complicated.  Next, the Tweet object:

``` csharp
public class Tweet
{
    private readonly JsonObject _json;

    public static bool TryParse(JsonObject value, out Tweet tweet)
    {
        if (value.ContainsKey("text") &value.ContainsKey("user"))
        {
            tweet = new Tweet(value);
            return true;
        }
        tweet = null;
        return false;
    }

    private Tweet(JsonObject json)
    {
        _json = json;
    }

    public string Text
    {
        get { return _json["text"].ToValueString(); }
    }

    public string ScreenName
    {
        get { return _json["user"]["screen_name"].ToValueString(); }
    }
}

internal static class TweetEx
{
    public static string ToValueString(this JsonValue s)
    {
        return s.ToString().Trim('"');
    }
}
```
To keep things simple I’m only extracting the screen name and text.  I won’t bore you setting up the views since it’s just simple ListBox bound to an `ObservableCollection<Tweet>`, and a DataTemplate for Tweet.  When it’s all said and done, we see something like this:

![img](http://lh3.ggpht.com/-sVzoQRx_V2s/TlqFswXVhUI/AAAAAAAAAFc/d9nLfBSrARA/image_thumb3.png?imgmax=800)

Performance is still good at 2-5% CPU, even though we’re scrolling through 1000 items in near real-time.

Stay tuned for part 3, when we introduce Expression Blend and go into basics of UI design.  Also, most of this will hit GitHub very soon.
