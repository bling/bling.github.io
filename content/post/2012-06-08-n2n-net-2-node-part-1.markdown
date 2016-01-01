---
layout: post
title: "N2N: .NET 2 Node: Part 1"
slug: n2n-net-2-node-part-1
date: 2012-06-08
comments: false
---

Let's get some actual coding done.  If you want some basic prologue, check out the first part of my series [here](/blog/2012/06/03/n2n-net-2-node/).

Anywho, let's get to the meat of what we're trying to accomplish.  I will start with the typical C# class you would write, do the same in Javascript, and then again in C#, but using the style of Javascript using closures.

Here's the use case:

* Handle a web request
* Check the MongoDB database to see if an entry exists and return it if available.
* Otherwise, query an external API for data, save it into MongoDB, and then return that.

This is a pretty standard straight-forward approach in web applications.  If you're not using MongoDB, you'll be using memcache, Redis, or some other equivalent data store.

First, let's implement an pseudo-code ASP.NET MVC controller which does the above:

``` csharp
public class QuoteController : Controller
{
    MongoCollection collection;
    IExternalApi external;

    public ActionResult Get(string symbol)
    {
        var quote = this.collection.FindOne(new { symbol });
        if (quote == null)
        {
            var json = this.external.GetQuote(symbol);
            this.collection.Save(json);
        }

        ViewBag.Quote = quote;
        return View();
    }
}
```

Error handling and initialization are omitted for brevity, but it's an otherwise straight-forward synchronous send JSON to the browser response.  So how does something like this look in Node?  First, let's throw in a web framework.  I picked Express because it seems to have the most traction right now.  Again, for brevity I will omit a bunch of boot strapping code, and skip to the core logic.

``` csharp
var QuoteService = function() {
    var mongoCollection; // new MongoCollection
    var external; // new External API

    // req/res are the request/response passed in by Node/Express
    this.get = function(symbol, req, res) {
        mongoCollection.findOne({ symbol: symbol }, function(error, item) {
            if (item === null) {
                external.getQuote(symbol, function(error, result) {
                    mongoCollection.save(result);
                    req.write(result);
                    req.end();
                });
            } else {
                req.write(item);
                req.end();
            }
        });
    };
};
module.exports = QuoteService;
```

OK, looks a lot different!  The first thing you'll notice is that the class is actually a function.  Javascript doesn't have real classes like C# or Java, but you can simulate things like private and public members by using closures.  In the code snippet above, *mongoCollection* and *external* are private variables.  However, the *get* function is public because it's prefixed with *this*.  Finally, because Javascript has closures you can still access the private variables and retain their state.

Last but not least, as far as programming in Node is concerned, every function returns void.  Node is extremely fast – but it is still single threaded, which means you need to take extreme care not to block on any operation.  In summary, you need to get used to working with callbacks. In the example above, the callback for the Mongo query invokes another function, which again uses a callback for the result.  Typically any errors are also passed through to the callback, so in place of try/catch blocks, you will be checking to see if the error parameter has a value.

To conclude, let's write a C# version that mimics the Javascript style.

``` csharp
public static void Main(string[] args)
{
    var QuoteService = new Func<dynamic>(() => {
        var mongoCollection = new MongoCollection();
        var external = new IExternalApi();
        return new
        {
            get = new Action<string, Request, Response>((symbol, req, res) =>
            {
                mongoCollection.FindOne(new{symbol}, (error, item) => {
                    if (item == null)
                    {
                        external.GetSymbol(symbol, (e, result) => {
                            mongoCollection.Save(result);
                            req.Write(result);
                            req.End();
                        });
                    }
                    else
                    {
                        req.Write(item);
                        req.End();
                    }
                });
            })
        }});
}
```

100% valid C# syntax.

Would you ever want to do that in C#?  Probably not.  But if you need some mental conversion from C# to/from Javascript, I think it's a good place to start.

In summary, Javascript is kind of like programming in C# using only anonymous classes, Action/Func, dynamic, declared all in the main method.

