---
layout: post
title: "Injecting Logger Instances Via Convention With Unity"
slug: injecting-logger-instances-via-unity
date: 2011-08-19
comments: true
tags: [ logging, coding ]
---
Let’s say you have something like this:
``` csharp
public void MyClass {
    public ILog Logger { get; set; }
}
```
And you simply want Unity to inject an instance of `ILog` such that its name is `requestingDependency.GetType().FullName`, which in this case would be `Full.Namespace.MyClass`.

I'll leave it up to the exercise of the reader, but if you search for 'log4net and Unity' you will find some working solutions which IMO are way too long to solve this.  I have obviously taken for granted the features of Windsor and Autofac too much because I expected something like this to be easily done in 2-3 lines of code.

After a lot of cursing I've come up with something that's almost as short and gets the job done:
``` csharp
public class LoggingExtension : UnityContainerExtension
{
    protected override void Initialize()
    {
        this.Context.Strategies.AddNew(UnityBuildStage.PreCreation);
    }
    private class LogBuilderStrategy : BuilderStrategy
    {
        private readonly Stack buildKeys = new Stack();
        public override void PreBuildUp(IBuilderContext context)
        {
            var type = ((NamedTypeBuildKey)context.BuildKey).Type;
            if (type == typeof(ILog))
            {
                if (this.buildKeys.Count < 1)
                    throw new InvalidOperationException("Log instances cannot be resolved directly.");
                context.Existing = LogManager.GetLog(this.buildKeys.Peek());
            }
            this.buildKeys.Push(type);
        }
        public override void PostBuildUp(IBuilderContext context)
        {
            this.buildKeys.Pop();
        }
    }
}
```
If you noticed, I had to cast to `NamedTypeBuildKey`, which unfortunately means I’m still stuck with Unity 1.2...
