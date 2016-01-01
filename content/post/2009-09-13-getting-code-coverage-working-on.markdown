---
layout: post
title: "Getting code coverage working on TeamCity 5 with something other than NUnit"
slug: getting-code-coverage-working-on
date: 2009-09-13
comments: false
categories:
 - testing
 - software tools
---
I've been experimenting lately with [TeamCity 5 EAP](http://www.jetbrains.net/confluence/display/TW/TeamCity+EAP?eap) and so far it's been a pretty awesome experience.  I was up and running within minutes and I was swarmed with beautiful graphs and statistics with specifics even per-test.  Getting something like that up with <a href="http://ccnet.thoughtworks.com/">CC.NET</a> is not a trivial task.


Anywho, with TC5 code coverage is one of the cool new features added for .NET, but unfortunately only [NUnit](http://nunit.org) is supported.  Not that that's a bad thing, but some people  prefer to use other testing tools.  Two notable contenders are [xUnit.net](http://xunit.codeplex.com) and [MbUnit](http://www.gallio.org).

I like the fact (pun intended) that xUnit.net makes it a point to prevent you from doing bad practices (like `[ExpectedException]`), and I like how MbUnit is so bleeding edge with useful features (like `[Parallelizable]` and a vast availability of assertions).

And with that I set up to figure out how to get TC working with Gallio, but the following should work with any test runner.

It certainly was a pain to set up because it took a lot of trial and error but eventually I figured it out.  I analyzed the build logs provided in each build report and noticed something interesting...specifically:
```
[13:51:23]: ##teamcity[importData type=’dotNetCoverage’ tool=’ncover’ file=’C:\TeamCity5\buildAgent\temp\buildTmp\tmp1C93.tmp’]
```
and
```
[13:51:30]: ##teamcity[buildStatisticValue key=’CodeCoverageL’ value=’94.85067’]
[13:51:30]: ##teamcity[buildStatisticValue key=’CodeCoverageM’ value=’97.32143’]
[13:51:30]: ##teamcity[buildStatisticValue key=’CodeCoverageC’ value=’98.68421’]
[13:51:30]: ##teamcity[buildStatisticValue key=’CodeCoverageAbsLCovered’ value=’921.0’]
[13:51:30]: ##teamcity[buildStatisticValue key=’CodeCoverageAbsMCovered’ value=’218.0’]
[13:51:30]: ##teamcity[buildStatisticValue key=’CodeCoverageAbsCCovered’ value=’75.0’]
[13:51:30]: ##teamcity[buildStatisticValue key=’CodeCoverageAbsLTotal’ value=’971.0’]
[13:51:30]: ##teamcity[buildStatisticValue key=’CodeCoverageAbsMTotal’ value=’224.0’]
[13:51:30]: ##teamcity[buildStatisticValue key=’CodeCoverageAbsCTotal’ value=’76.0’]
```
The first message happens after NCover.Console is done its thing.  After NCoverExplorer is done its thing, the statistics are published.  I set out to mimic this functionality with Gallio, but what's described here should work with any test runner.

1. Disable code coverage in TC.  We're doing it manually instead.
2. In your build script, run your unit tests with NCover and generate a coverage.xml report.
3. Run NCoverExplorer on coverage.xml and generate reports ncoverexplorer.xml and index.html.
4. Create a zip file of index.html and name it coverage.zip.
5. Configure coverage.zip to be an artifact in your TC configuration (this is to enable the tab).
6. Parse out ncoverexplorer.xml with XPath and output the statistics.

Certainly a lot of things to do just for the sake of pretty statistics reporting....but it was the weekend and I was bored.  With the help of [MSBuildCommunityTasks](http://msbuildtasks.tigris.org/), the zip file and XML parsing was made a lot easier.

After that, viola!  Code coverage + Gallio on TeamCity 5!!!

Unfortunately, NCoverExplorer's report only reports the # total of classes and nothing about unvisited or covered, so for those values I set to 0/0/0 (BTW, you need all values present for the statistics to show).  A task for next weekend!!!

(Edit: I suppose I could should also mention that you could technically avoid all the trouble above and hack it with this:
```
#if NUNIT

using TestFixtureAttribute = NUnit.Framework.TestFixtureAttribute;

using TestAttribute = NUnit.Framework.TestAttribute;

#endif
```
And it'll work just fine as well).
