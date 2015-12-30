---
layout: post
title: "MetaTrader Indicators"
date: 2009-05-05
comments: false
categories: forex
---
One of my hobbies is forex trading, and a sub-hobby of that is writing custom indicators.  MetaTrader is a trading platform that is very popular in the forex community because it allows traders to write custom indicators.  It's pretty easy to get started if you have programming experience because the language is very similar to C.  And yes, you can also write your own bot if you wanted, called an Expert Advisor.

Personally I don't spend too much time trying to write a winning bot simply because there are way too many variables to take into account, and eventually the market's going to yell "in your face" and your winning bot will end up losing.  I just write simple scripts that help me identify entry points, and filter out all the non-interesting price movements.

Recently I've been looking at breakout strategies because they are simple, yet effective.  The result is a custom indicator I wrote which simply put calculates the high and low for a time period, and then draws pretty rectangles.  Like so:

![img](http://imgur.com/2ceH.gif)

The above is simply the high/low of 2 hours before the opening London session, and the opening US session.  Isn't it puurrrrrrty?
