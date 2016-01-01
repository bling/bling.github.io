---
layout: post
title: "Dynamic proxies"
date: 2009-08-08
comments: false
tags: [ 'castle', 'coding' ]
---

Life has sure been a roller coaster lately ever since I started working on my new project. I've learned a lot about WCF in the past week. There's really nothing that can teach you faster than trying something out yourself.

I've joined the ranks of countless others who have had to deal with implementing service behaviors to handle WCF exceptions (because by default thrown exceptions fault the communication channel), realized that WCF proxy clients breaks the 'using' keyword because someone thought it was a good idea to throw exceptions in Dispose(), and even Unity's InterfaceInterceptor not [supporting more than 1 interface](http://unity.codeplex.com/WorkItem/View.aspx?WorkItemId=3685)!

But now that we're talking about proxies, I've been thinking for a while about switching out Unity with a more mature IoC container like Windsor or StructureMap. There are little touches that other containers have that I miss in Unity. For example, auto-wiring.

But then again, the integration that Unity has with the rest of the Enterprise Library is very nice, of which I'm using the Logging and Exception Policy blocks, so it made sense in a way that everything in my bin folder just had Microsoft.Practices.*.dll.

But now I'm seriously reconsidering.

``` csharp
public interface ITestService {
  int Count { get; set; }
  void DoWork();
  bool ShouldDoWork();
}

public class TestService : ITestService {
  public int Count { get; set; }
  public void DoWork() { ++Count; }
  bool ShouldDoWork() { return true; }
}

public void HowDoTheyCompare() {
  var unity = (ITestService)new Microsoft.Practices.Unity.InterceptionExtension.InterfaceInterceptor()
                   .CreateProxy(typeof(ITestService), new TestService());
  var castle = new Castle.DynamicProxy.ProxyGenerator()
                   .CreateInterfaceProxyWithTarget<ITestService>(new TestService());

  Thread.Sleep(1000);

  Stopwatch sw = new Stopwatch();

  sw.Start();
  for (int i = 0; i < 1000000; ++i) { if (unity.ShouldDoWork()) unity.DoWork(); }
  sw.Stop();
  Console.WriteLine("unity: " + sw.ElapsedMilliseconds);

  sw.Reset();
  sw.Start();
  for (int i = 0; i < 1000000; ++i) { if (castle.ShouldDoWork()) castle.DoWork(); }
  sw.Stop();
  Console.WriteLine("castle: " + sw.ElapsedMilliseconds);
}
```

Results?
<br>
unity: 1787
castle: 136

From this test it looks like the Unity interception is 13x slower....but wait! I mentioned before that Unity has a bug where it can only proxy one interface....so to resolve that we would need to use the TransparentProxyInterceptor.

Let's change it and test again...
<br>
unity: 30462
castle: 142

Hmmmm....214x slower. I guess we can try the VirtualMethodInterceptor for completeness. After making all methods virtual, here's the results.
<br>
unity: 3843
castle: 132

Still 29x slower. Whatever DynamicProxy is doing...it's orders of magnitude faster than what Unity's doing.

Comments
--------

<div class="comments">

<div class="comment">

<div class="author">

Krzysztof Koźmic (2)

</div>

<div class="content">

Not only that. Castle has integration with logging, validation
framework, much more mature and powerful IoC container, and also nice
proxy library.

</div>

</div>

</div>
