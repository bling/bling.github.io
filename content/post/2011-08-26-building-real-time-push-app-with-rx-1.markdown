---
layout: post
title: "Building a Real-time Push App with Silverlight: Part 1"
slug: building-real-time-push-app-with-rx-1
date: 2011-08-26
comments: true
tags: [ 'rx', 'coding' ]
---
This is the beginning of a multi-part series where I’ll be building an interactive application with Silverlight 5 (still beta as of this post).  It will be built from the ground up and designed predominantly from a “push data” point of view, where the application is reacting to events in real-time, rather than a more traditional “pulling” point of view.  This type of application has exploded with the popularity of social networking and has made a lot of the traditional methods of building applications obsolete.

The best example of this shift is from Twitter.  When it first came out, it was (and still is predominantly) a “pull” model.  You have 200 API requests an hour, and you pull Twitter whenever you want to check if there are tweets of people you follow.  That is changing with the [Streaming API](https://dev.twitter.com/docs/streaming-api) where data is “pushed” to you as it comes.  This changes the way you write your code and requires a mind shift much like from for loops to LINQ.

The primary purpose of this series is build a real-time push application from beginning to end, and to show any problems I run along the way, and how I managed to solve them.  This will be my first attempt at building a Silverlight application as well as learning [Reactive Extensions](http://msdn.microsoft.com/en-us/data/gg577609), so I’m bound to run into newbie mistakes.  If you have any tips or pointers please let me know!

Also, rather than doing this from a purely technical point of view, I’m also going to put on my designer hat and talk about UI design, and make it look good with Expression Blend when I get to designing the UI in later parts of this series.  I feel that this is often overlooked and can result in a lot of wasted work and lead to frustration.

This first post will be to get up and running and connected to Twitter with the Streaming API. This was chosen primarily because it is so much data can be pushed through and it can be used to demonstrate how to write a high performance Silverlight application.  It’s one thing to write something maintainable, and another altogether to make it run fast as well.  I’ve worked on too many WPF projects where performance took a back seat, and in WPF particularly this tends to create some massive technical debt.  The Silverlight/WPF technology stack is an exception to the rule and you should definitely think about performance from the start.

Well let’s get started!  We will connect to Twitter, convert it to an Observable, and then display tweets on the UI.

First, let’s create our TwitterStream class:

``` csharp
public class TwitterStream
{
    static TwitterStream()
    {
        // this allows http authentication to work
        WebRequest.RegisterPrefix("http://", System.Net.Browser.WebRequestCreator.ClientHttp);
    }

    protected readonly StreamParser parser = new StreamParser();

    public string Username { get; set; }
    public string Password { get; set; }

    protected HttpWebRequest GetRequest()
    {
        var request = WebRequest.CreateHttp("http://stream.twitter.com/1/statuses/sample.json?delimited=length");
        request.UseDefaultCredentials = false;
        request.Credentials = new NetworkCredential(Username, Password);
        return request;
    }

    public IObservable<string> GetJsonStreams()
    {
        var request = GetRequest();
        return Observable.FromAsyncPattern<WebResponse>(request.BeginGetResponse, request.EndGetResponse)()
            .Select(wr => wr.GetResponseStream())
            .Select(str => Observable.FromAsyncPattern<byte[], int, int, int>(str.BeginRead, str.EndRead))
            .SelectMany(ParseJson);
    }

    private IEnumerable<string> ParseJson(Func<byte[], int, int, IObservable<int>> reader)
    {
        var buffer = new byte[256];
        int bytesRead;

        while ((bytesRead = reader(buffer, 0, buffer.Length).Single()) > 0)
        {
            foreach (var json in parser.Parse(buffer, bytesRead))
                yield return json;
        }
    }
}
```
And that’s all there is to it!  The most complicated part is probably parsing of the JSON documents themselves, which I refactored into its own class.  The algorithm in the parser is pretty primitive, as it just looks for opening { and closing } and calls that a document – nothing more, nothing less.  Note that this uses the deprecated basic HTTP authentication.  Sooner or later it will be shut down and OAuth will be required, so I will upgrade when that happens as I want to keep the amount of written code to a minimum.

Perhaps the more interesting bit is this part with Rx:

``` csharp
Observable.FromAsyncPattern<WebResponse>(request.BeginGetResponse, request.EndGetResponse)()
    .Select(wr => wr.GetResponseStream())
    .Select(str => Observable.FromAsyncPattern<byte[], int, int, int>(str.BeginRead, str.EndRead))
    .SelectMany(ParseJson);
```

The API takes some getting used to, but once you “tune in” things start to make sense.  The `FromAsyncPattern` essentially wraps the [APM](http://msdn.microsoft.com/en-us/library/ms228969.aspx) pattern’s Begin/End calls into a single `Func<>`, which when invoked gets you the result as if you called End(), however without all the tedious AsyncCallback implementation.

The nice thing about this wrapper Func is that the code starts to look synchronous, even though it is using the ThreadPool behind the scenes.  Next, the response is projected into its response stream, which again is converted to another Observable for reading bytes from the stream until finally it goes into the `ParseJson` method which projects string results.  This is both good and bad.  Good in that it can make asynchronous code look short and succinct (in this example I’ve wrapped 2 APM pattern calls in 2 lines of code), bad in that anyone inexperienced with Rx will get lost pretty fast.

Rx thus far has been a fairly high learning curve.  Maybe it’s just me.  When I read about it from others, or from seminars, it all makes sense and I generally don’t have any questions.  Trying to use it directly is another story, as there are so many overloads it’s easy to get overwhelmed.  I feel like Intellisense is making things worse!

Carrying on, the code above actually doesn’t do anything yet.  First, you must Subscribe to an observable before it does something, similar to you must foreach on a IEnumerable before it starts pulling data.

To finish off, let’s create a simple Window with a TextBlock bound to a Text property.  This is the constructor:

``` csharp
public MainPage()
{
   InitializeComponent();
   DataContext = this;

   var s = new TwitterStream();
   s.Username = "blingcoder";
   s.Password = "1234567";
   s.GetJsonStreams()
       .ObserveOnDispatcher()
       .Subscribe(x => Text = x);
}
```

Perhaps one of the nicest features of Rx is automatic thread switching between background threads and UI threads.  Above, there is a call to `ObserveOnDispatcher`, which as the name implies it observes to events on the Dispatcher thread :-).  Rx automatically handles switching to the UI thread so when Subscribe occurs we’re on the UI thread.

Performance is also very good so far, only maxing out at 5% CPU for what appears to be a continuous flood of tweets from random people.

And there you have it!  A completely asynchronous streaming Twitter client in roughly 20 lines of code (minus the parsing).  Stay tuned for part 2...
