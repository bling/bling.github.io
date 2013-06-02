---
layout: post
title: "On TypeScript"
date: 2013-04-19 23:31
comments: true
categories: coding
---

# What's the deal?

For the past week I've been fortunate to work on an internal project which was purely greenfield and built on Node/Express on the backend, and AngularJS on the front-end.  It was a ton of fun and I learned a lot in the process, most particularly TypeScript and CoffeeScript.

TypeScript was of interest because the application I was writing contained some pretty complex calculations.  The existing implementation was in Java, and at first glance it seemed like it would be a good idea to have some type safety whilst reimplementing the algorithm.

<!--more-->

# Getting Started

I don't know why there's this misconception that you need to have Microsoft tooling to use Typescript, but it is 100% false and a myth.  To install it you just run `npm install typescript`.  Yes!  It's just a standard node package.  Once it's installed you have access to a `tsc` command, similar to how you would use the `coffee`, i.e. you give it input, and it spits output.

If you've ever been to [TypeScript](http://typescriptlang.org)'s website, you will have seen the rather impressive playground where you can see side by side Javascript vs Typescript.  This is a trick!  It gives you the illusion that you can simply annotate variables with types and it will automatically check only those types.  This is only half true.  Let's look at a innocent Node application:

``` javascript
var http = require('http');
http.createServer(function(req, res) {
  res.write('hello world');
  res.end();
}).listen(3000);
```

That is just plain 'ol Javascript, and if the claim that all Javascript is valid Typescript, this should compile fine.  Except that it doesn't...we are greeted with the following error:

```
The name 'require' does not exist in the current scope.
```

As it turns out, if you're using Typescript you need to tell the compiler of _every_ object and function that you're using.  In the above example, the compiler doesn't know anything about `require`, so it threw an error.

The way to correct this is with definition files.  These are like header files and they define the API of a module.  The pseudo standard for definition files currently lives in a GitHub repository named [DefinitedlyTyped](https://github.com/borisyankov/DefinitelyTyped).  This contains definition files for many popular libraries and is actively updated by the community.

Once you have a definition file, you add `///<reference path="./d.ts/requirejs/require.d.ts"/>` to the top of the file, and the code will compile.

The second option is to add `declare var require: any;` to the top of the file, effectively telling the compiler to ignore anything to do with that variable.

Either way, this was completely different from my initial expectations.  I thought that I would be able to take a large application, rename everything from `js` to `ts`, and then slowly upgrade the code to Typescript.  This is obviously not possible.  For this to work, you would need to define an application definition file, which references all other definition files (or declare variables for those that do not have definition files), and then for _every file in your project_, you would ///reference the application definition file.

I suppose this is a necessary evil for type checking, although it would have been nice to have this baked into the compiler to ease the migration path of existing applications.

# Clean output

One of the nice things about TypeScript is that the output is very clean and predictable.  For example, here is an empty class:

``` javascript
class Foo { }
```

It will compile to this:

``` javascript
var Foo = (function() {
    function Foo() { }
    return Foo;
})();
```

All classes are done so with an immediately executed anonymous function.  If you define `Foo` as `export class Foo`, then the output will have an extra line at the bottom: `exports.Foo = Foo;`.  In other words, it's got first class support for the CommonJS syntax (as well as AMD).

# Competing thought processes

For people coming from C#, it will feel very comfortable, because it is _extremely_ similar to C#.  You have classes, methods, modules (aka namespaces), just like you have in C#.  If you try to use a method that doesn't exist, the compiler will complain.  These features are the bread and butter of compiled languages and people coming from Visual Studio (the majority of the audience) will feel very comfortable.

Then why is it that I did _not_ enjoy writing in Typescript?

I'm about 99% sure that I was just so used to working in untyped Javascript that I became annoyed that I had to "annotate yet another variable".  TypeScript doesn't force you to annotate every variable, in fact, you could annotate nothing and it'll still compile (as long as you have the definition files).  But if you're going to use TypeScript it seems silly not to use types.

But what this comes down to is the classic static vs dynamic languages.  Static proponents will state that the compiler saves you from a lot of mistakes earlier on.  Dynamic proponents will state that "if it quacks like a duck, it's a duck, I shouldn't need to declare it".  They're both right.

Either way, given an open mind and some time, you can be productive in either environment, and makes you a better developer in the end.
