---
layout: post
title: "Improving Your Unit Testing Skills"
date: 2009-10-19
comments: false
tags: testing
---
Unit testing is *hard*!  I came to this sad realization when my code which had a large test suite with near 100% code coverage, with every thought-of requirement unit tested, failed during integration testing.

How is that possible?  I thought to myself.  Easy...my unit tests were incomplete.

Writing software is pretty complex stuff.  This is pretty evident in the level of difficulty in determining how good a software developer is.  Do you measure them based on lines of code?  Can you measure on time to completion of tasks?  Or maybe the feature to bugs coming back ratio?  If writing features alone can be this complicated, surely unit testing is just as (or more) complicated.

First, you must be in a place where you can even *start* testing your code.  Are you using dependency injection?  Are your components decoupled?  Do you understand mocking and can you use mocking frameworks?  You need an understanding of *all* these concepts before you can even begin to unit test effectively.  Sure, you can unit test without these prerequisites, but the result will likely be pain and more pain because the you'll be spending 90% of your time setting up a test rather than running it.

But back to the point of this post.  Unit testing is hard because it's one of those things where you'll never really know how to do it properly until you've tried it.  And that assumes you've even made the step to do testing at all.

I'm at the point where my experience with writing unit tests allows me to set them up quickly with relative ease, and perform very concise tests where anyone reading the unit test would say "oh, he's testing this requirement."  However, the problem is that there's still 2 problems that are hard to fix:
1. Is the test *actually* correct?
2. Do the tests cover *all* scenarios?

(1) is obvious.  If the test is wrong then you might as well not run it all.  You must make it absolute goal to trust your unit tests.  If something fails, it should mean there's a serious problem going on.  You can't have "oh that's ok, it'll fail half the time, just ignore it."

(2) is also obvious.  If you don't cover all scenarios, then your unit tests aren't complete.

In my case, I actually made both errors.  The unit test in question was calculating the time until minute X.  So in my unit test, I set the current time to 45 minutes.  The target time was 50 minutes.  5 minutes until minute 50, test passed.  Simple right?  Any veteran developer will probably know what I did wrong.  Yep...if the current time was 51 minutes, I ended up with a negative result.  The test was wrong in that it only tested half of the problem.  It never accounted for time wrapping.  The test was also incomplete, since it didn't test all scenarios.

Fixing the bug was obviously very simple, but it was still ego shattering knowing that all the confidence I had previously was all false.  I went back to check out other scenarios, and was able to come up with some archaic scenarios where my code failed.  And this is probably another area where novice coders will do, where experienced coders will not: I only coded tests per-requirement.  What happens when 2 requirements collide with each other?  Or, what happens when 2 or more requirements must happen at the same time?  With this thinking I was able to come up with a scenario which led to 4 discrete requirements occurring at the same time.  Yeah...not fun.

Basically, in summary:
- Verify that your tests are correct.
- Strive to test for less than, equal, and greater than when applicable.
- Cross reference all requirements against each other, and chain them if necessary.
