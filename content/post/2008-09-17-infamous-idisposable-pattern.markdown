---
layout: post
title: "The Infamous IDisposable Pattern"
slug: infamous-idisposable-pattern
date: 2008-09-17
comments: false
categories: coding
---
At one point or another, any .NET developer should come across the concept of implementing the IDisposable pattern. For more detail, visit this excellent article at http://www.codeproject.com/KB/cs/idisposable.aspx.

One of the most common errors of programmers with a C++ background is that they define the Finalize() method with ~() syntax. This is almost always wrong. Just like you should never call GC.Collect(), you should not define a finalizer most of the time. The destructor is only required if your class uses unmanaged resources. If it does, then you should implement both the destructor and IDisposable, which simply contains a public Dispose() method which is where you deterministically clean up resources. Finalizers are called during garbage collection.

The typically class template is this:
``` csharp
class Foo : IDisposable {
    private bool _disposed = false;
    ~Foo() {
        Dispose(false); // this is called automatically by the GC when you forget to call Dispose() explicitly.
    }
    public void Dispose() {
        Dispose(true);
        GC.SuppressFinalize(this); // this prevents the GC from calling the finalizer, since you deterministically cleaned up resources already by calling Dispose().
    }
    protected void Dispose(bool disposing) {
        if (disposing) {
            //dispose unmanaged resource
        }
        _disposed = true;
    }
}
```
Since I'm on the subject of IDisposable, please for the love of God, use the keyword 'using' whenever possible. It makes the code much cleaner, easier to read, and safer. Compare the following:
``` csharp
public void Print(string path) // implemented with using
{
    try
    {
        using (StreamReader r = new StreamReader(path))
        {
            string line;
            while ((line = r.ReadLine()) != null)
                Console.WriteLine(line);
        }
    }
    catch { }
}

public void Print(string path) // implemented without
{
    StreamReader r = null;
    try
    {
        r = new StreamReader(path);
        string line;
        while ((line = r.ReadLine()) != null)
            Console.WriteLine(line);
    }
    catch { }
    finally
    {
        if (r != null)
            r.Close();
    }
}
```
I don't think I need to tell you the 1st section of code is much cleaner, robust, and easier to read than the 2nd section of code. The finally section is crucial as well. If you don't have this section, and some part of your code throws an exception, you probably just leaked resources. Just because .NET has a garbage collector does NOT mean you can be lazy about memory. You can and you will leak memory if you're not mindful of these things.
