---
layout: post
title: "Building a Real-time Push App with Silverlight: Part 8"
slug: building-real-time-push-app-with-rx-8
date: 2011-09-21
comments: true
categories: [ coding, twitter ]
---

# Exploring Caliburn Micro

As I hinted in earlier posts, Caliburn Micro has some wicked conventions that makes for writing MVVM super easy, and it also have a very convenient syntax for hooking up events.  For example, the following:

``` xml
<Button Content="R">
   <i:Interaction.Triggers>
       <i:EventTrigger EventName="Click">
           <i:InvokeCommandAction Command="{Binding ReplyCommand}" CommandParameter="{Binding}" />
       </i:EventTrigger>
   </i:Interaction.Triggers>
</Button>
```

Can be rewritten like this:

``` xml
<Button Content="R" cal:Message.Attach="[Reply($dataContext)]" />
```

There are some smarts going on here.  Caliburn Micro will default to the Click event for buttons.  For a full syntax, it would be `cal:Message.Attach="[Event Click] = [Reply($dataContext)]"`.  As you can imagine, that will call the Reply method and pass in the current data context.  You can also pass in other things like `$this`, `$source`, or `$executionContext` for full access to anything and everything Caliburn Micro itself has access to.

The coolest thing about this is it gives you some wicked control over how your data context gets set.  Ever struggled with popup windows or data grids and using weird hacks to get the binding correct?  Caliburn Micro makes this very easy.  Here’s an example.

1. I have a DataTemplate which renders the UI for the model Tweet.
2. Tweet is just a simple class which holds only properties.
3. Inside the DataTemplate, I have some buttons that when the user clicks will reply, retweet, quote, or direct message.

The Tweet class is purely for modeling data, so adding any methods would be bad practice.  Also, since I’m in a DataTemplate I can’t easily reference another control with ElementName (in this case I need the containing parent’s DataContext).  And to add insult to injury, Silverlight 4 doesn’t have RelativeSource ancestor type.  So how do I solve this?

``` xml
<StackPanel VerticalAlignment="Bottom" cal:Action.TargetWithoutContext="shell" Orientation="Horizontal">
    <Button Content="R" cal:Message.Attach="[Reply($dataContext)]" />
    <Button Content="RT" cal:Message.Attach="[Retweet($dataContext)]" />
    <Button Content="Q" cal:Message.Attach="[Quote($dataContext)]" />
    <Button Content="DM" cal:Message.Attach="[DirectMessage($dataContext)]" />
</StackPanel>
```

The secret is the attached property TargetWithoutContext.  As the name implies, it will set the target for all the ActionMessages attached to all the buttons, without setting the context.  If I used the Target attached property, it would set all of the Buttons’ data context to the same object – not what we want.  Since the Button’s data context remains intact, we can call “Reply($dataContext)”, which calls the Reply method on the target object (set on the StackPanel) and pass in the Tweet.  “shell” is the key of the service that I registered into the container.

Originally I wanted this entire series to be able writing a fast push data app with Silverlight and Rx, and now I’m finding that I’m writing an entire Twitter client because it’s so much fun :-).

I’m going to make another release soon.  While the first release was merely experimental, the next one will be useful enough to potentially use full time.  As you can probably tell with this blog post, it supports all the actions mentioned previously (and it’ll appear on mouse hover):

![img](http://lh5.ggpht.com/-RIZG8I0_rik/TnqqmNCK-6I/AAAAAAAAAHM/-xU4_cj6iDg/image_thumb%25255B2%25255D.png?imgmax=800)

The tweet box is much improved and shows you how many character you have left:

![img](http://lh4.ggpht.com/-2VhCjjYrcoo/TnqqmstbbUI/AAAAAAAAAHU/zK65JB2shQw/image_thumb%25255B3%25255D.png?imgmax=800)

And it’s smart enough to auto wrap http links via Twitter’s t.co service, and the counter takes that into account.  Some interesting things to note is that in the future *all links* will be wrapped t.co.  Looks like Twitter is trying to eat up bt.ly or something.

Clicking on @users and #topics will automatically open a new timeline and subscribe to those tweets.  It is almost full featured enough to become my main Twitter client.  There are certain features still missing, and it’s purely based on when I have time to port them over.

As always, you can install directly from [here](http://dl.dropbox.com/u/2072014/Ping.Pong/PingPongTestPage.html), or you can grab the code on the [GitHub](https://github.com/bling/Ping.Pong) page!

Next post will be about Rx from a very top level perspective and how it influenced my code from beginning to be experienced and all refactorings in between.  Stay tuned!
