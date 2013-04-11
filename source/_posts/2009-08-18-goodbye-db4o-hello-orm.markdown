---
layout: post
title: "Goodbye db4o, Hello ORM"
date: 2009-08-18
comments: false
categories: coding
---
It's unfortunate that I have to remove db4o from my project, but I can't say this was unexpected.  The CTO finally came to me today to voice his concerns on using an object database rather than a relational database.

As typical of many organizations, we have a database team dedicated to maintaining the integrity and performance of our main product.  We are also stored procedure happy and every write *and read* operation goes through a stored procedure....so you can say I was pretty gutsy to even consider using an object database ;-)

It was fun nonetheless...

Sooooo....which ORM to use?  I've already read of [all the things about the Entity Framework](http://lmgtfy.com/?q=entity+framework+vote+of+no+confidence) already, so I didn't even bother considering it.  Choices came down to just a few:
- [Castle.ActiveRecord](http://www.castleproject.org/activerecord/index.html)
- [Fluent NHibernate](http://fluentnhibernate.org/)
- [SubSonic](http://www.subsonicproject.com/)


I've initially started with Fluent NHibernate.  The main reason is because it's got really good documentation for beginners like me who've never used NHibernate, and has more configuration options via code.  Even so, it didn't take long for me to run into gazillions of mapping errors though :-[

I'm still undecided whether I prefer `ClassMap<>` or `ActiveRecord` attributes though...

I started porting all my repositories to using NHibernate, and for the most part it wasn't too bad.  I've learned some things along the way like lazy loading and cascading, but the conclusion is having Fluent NHibernate with pretty code completion isn't going to prevent the need to actually learn NHibernate the old-fashioned way, although it definitely got me up and running a lot faster.

I'll probably write up a quick repository implementation with SubSonic as well as part of my prototype to see which I like.  SubSonic definitely looks more 'hip' with it's very flashy and web 2.0ey looking website :)
