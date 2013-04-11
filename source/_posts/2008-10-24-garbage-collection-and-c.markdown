---
layout: post
title: "Garbage Collection and C++"
date: 2008-10-24
comments: false
categories: coding
---
Why doesn't C++ have garbage collection? Simply put, it doesn't need it. C++ has something called Resource Acquisition Is Initialization. What this means is that programmers can deterministically know when an object is created and when it is destroyed. You do not have the same information with garbage collected languages. For example, in C# you know when an object is created (when you call new), but you have no idea when the object gets destroyed. C++ heavily relies on RAII, and smart pointers make very good use of this idiom.

For instance, take a look at the following C++ code:
```
class Foo
{
    Foo() { std::cout << "constructed!" << std::endl; }
    ~Foo() { std::cout << "destroyed!" << std::endl; }
};
int main()
{
    Foo a;
    if (true)
    {
        Foo b;
    }
}
```
With the above code, the following is the output:
constructed! (from a)
constructed! (from b)
destroyed! (from b after exiting the if block)
destroyed! (from a exiting the main function)

The programmer can determine exactly when the destructor of the variable 'b' is called, and that is when the if block is finished. Likewise, the destructor of 'a' is called when the main function exits. This is called stack unwinding. In C++, all variables on the stack (locally declared variables) are destroyed when a function block terminates. This is RAII at work.

While we're on this topic, it leads nicely into why C++ doesn't need a finally block as well. The finally block is meant for garbage collected languages to ensure that everything is cleaned up even if an exception is thrown. While it may sound like C++ needs this just as much, that is not true. With RAII, when an exception is thrown, the block terminates, and thus all objects declared on the stack will have their destructors called and memory is released.

Smart pointers, such as boost's shared_ptr implementation which uses reference counting, take advantage of RAII and takes care of the hassle with managing heap variables. It does magic in the background (that's why it's called smart, right?) and automatically calls 'delete' when the pointer is no longer used by any part of the program.
