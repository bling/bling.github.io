---
layout: post
title: "No more cross thread violations!"
slug: cross-thread-operation-not-valid
date: 2009-04-09
comments: false
tags: coding
---
“Cross thread operation not valid: Control ### accessed from a thread other than the thread it was created.”

Seriously, I don’t think there’s a single person who’s written UI programs for .NET that has not encountered this error.  Simply put, there is only 1 thread which does drawing on the screen, and if you try to change UI elements in a thread that’s not the UI thread, this exception is thrown.

A very common example is a progress bar.  Let’s say you’re loading a file which takes a long time to process, so you want to notify the user with a progress bar.
``` csharp
  public event EventHandler<IntEventArgs> ValueProcessed;
  private void StartProcessing() {
    ValueProcessed += ValueProcessedHandler;
    Thread t = new Thread(delegate() {
      for (int i = 0; i < 1000; ++i) {
        // do stuff
        ValueProcessed(this, new IntEventArgs(i));
    });
    t.Start();
  }
  private void ValueProcessedHandler(object sender, IntEventArgs e) {
    _progressBar.Value = e.Value;
  }
```
I left some implementation details out, but you can pretty much infer what IntEventArgs is, etc.  Once you try to set Value, it’ll throw an cross-thread exception.  A common pattern to solve this problem is this:
``` csharp
  private void ValueProcessedHandler(object sender, IntEventArgs e) {
    if (this.InvokeRequired) {
      this.BeginInvoke(ValueProcessedHandler, sender, e);
    } else {
      _progressBar.Value = e.Value;
    }
  }
```
It gets the job done…but frankly I’m too lazy to do that for every single GUI event handler I write.  Taking advantage of anonymous delegates we can write a simple wrapper delegate to do this automatically for us.
``` csharp
static class Program {
  public static EventHandler<T> AutoInvoke<T>(EventHandler<T> handler) where T : EventArgs {
    return delegate(object sender, T e) {
      if (Program.MainForm.InvokeRequired) {
        Program.MainForm.BeginInvoke(handler, sender, e);
      } else {
        handler(sender, e);
      }
    };
  }
}
```
This assumes that you set Program.MainForm to an instance to a Control, typically, as the name implies, the main form of your application.  Now, whenever you assign your event handlers, you can simply do this:
``` csharp
    ValueProcessed += Program.AutoInvoke<IntEventArgs>(ValueProcessedHandler);
```
Pretty neat!

BTW, just a word of warning, if you plan on using the same thing to unsubscribe an event with -=, it's not going to work.  Unfortunately, calling the AutoInvoke method twice on the same input delegate returns 2 results where `.Equals` and `==` will return false.  To get around this you can use a Dictionary to cache the input delegate.
