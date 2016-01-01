---
layout: post
title: "Auto Mocking NSubstitute with Castle Windsor"
slug: auto-mocking-nsubstitute-with-castle
date: 2010-12-11
comments: false
tags:
 - testing
 - castle
 - coding
---

I was debating whether to make this blog post because it’s so damn
simple to implement, but hey, if it saves someone else time, I did some
good.

First of all, register an ILazyComponentLoader into Windsor:

``` csharp
var c = new WindsorContainer();
c.Register(Component.For<LazyComponentAutoMocker>());
```

Then, the implementation of LazyComponentAutoMocker is simply this:

``` csharp
public class LazyComponentAutoMocker : ILazyComponentLoader
{
  public IRegistration Load(string key, Type service, IDictionary arguments)
  {
    return Component.For(service).Instance(Substitute.For(new[] { service }, null));
  }
}
```

And you’re done!  Here’s a simple unit test example using **only** the
code from above:

``` csharp
[Test]
public void IDictionary_Add_Invoked()
{
  var dict = c.Resolve<IDictionary>();
  dict.Add(1, 1);
  dict.Received().Add(1, 1);
}
```

That was almost too easy.

<h2>Comments</h2>
<div class='comments'>
<div class='comment'>
<div class='author'>Randy</div>
<div class='content'>
For what it&#39;s worth, I found this helpful. I&#39;m new to Castle Windsor as well as NSubstitute. This post was able to get me going a lot quicker than sifting through documentation. Thanks.</div>
</div>
</div>
