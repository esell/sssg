---
title: My adventures in self-hosting part 2
author: crimepigeon
date: September 24, 2018
---
Over a year ago I published a post on my initial [adventures in self-hosting](https://esheavyindustries.com/2017/03/my-adventures-in-self-hosting/) outlining 
what I was using, what I was trying to get rid of, etc. Awhile back a friendly e-mail came in from someone who had read that post (thanks!) suggesting 
I follow-up with how things are going and any other tools I started using. Well my friend, here is that post!


Let's start with what has been a **success...**


Creating and hosting this site with [Hugo](https://gohugo.io/), [Caddy](https://caddyserver.com/) and [Let's Encrypt](https://letsencrypt.org/) has been fucking awesome. I don't use any complicated build systems like I've seen others
using. For me I am happy with a git repo where the output from Hugo is stored and then the [Caddy git plugin](https://caddyserver.com/docs/http.git). Write content, use Hugo to generate the site and 
then do a `git push` and a minute or two later the new post is live. Doesn't get much easier than that. 10/10, would buy again.


While I'm talking about this site, using [GoAccess](https://goaccess.io/) has been great as well. For me (again), it works fine and gives me the data I care about. 
Does it have all the functionality of Google Analytics? Nope, but I don't need or want that so I am not missing anything. Another great example of software that just works.
My only minor complaint is the current lack of ability to filter dates/times in the web UI to look at a specific range. Depending on how your logs are setup though this
might not be a big deal to you. I've also seen a pretty easy way to mimic this functionality but have not tried it yet.


Password management was one of the larger things I wanted to get up and running and had two great experiences. In my previous entry I talked about [pass](https://www.passwordstore.org/) 
which is a fantastic tool. Unfortunately, it doesn't work well for groups (a family in my case) and non-technical users. I needed a way for my family and I to store and 
access various logins on our mobile devices and our laptops so I decided to take a look at [Bitwarden](https://bitwarden.com/). After a day or two of usage I was confident
that this was the solution for us. The "install" is painless as the suggested method is via Docker. The requirement of SQL server is kind of a bummer, but again, containers. 
If you really hate SQL server, there are many 1:1 compatible backends written in various other languages that don't have this requirement. 
How about the clients? Fantastic. For an open source project, the mobile clients are some of the most polished I've seen and easy-to-use for the non-technology folks.


It wasn't called out in my first post, but I also ended up running my own [Wallabag](https://wallabag.org/en) instance and it's awesome. Not really much to say outside of the fact that it works
and gives me a way to keep track of all the articles I'll never read. Go give it a try.


Now for the "failures". I have failures in quotes because while some of these ended up not working for me, it typically had nothing to do with the product itself, but
the ability to get others on board.


First up was my self-hosted code mess. If you look at my first post you'll see that I had decided to use [Gitea](https://gitea.io/) as well as [Drone](https://github.com/drone/drone) and a bit of custom glue and magic.
This whole setup was great and I was really happy with it, the problem is that it made it really hard to get other people to use it. I kept mirrors of my repos on
Github with a note pointing people to my self-hosted site thinking that would help a bit, but it didn't. 
The first problem was that in order for someone to open an issue or PR on my self-hosted repo they needed to have 
an account. Gitea added the ability to auth with your Github account which was nice, but that didn't totally solve the problem. As an example, take a PR. On Github you fork the repo,
make your changes and use the fancy PR button to create the PR at the upstream repo. Well, since nobody else used my self-hosted Gitea instance, nobody had code there. They
were typically (100%) forking from Github which meant you couldn't create a PR with those changes on my self-hosted Gitea instance. The solution was for them to come over to my
self-hosted instance, login with their Github credentials, fork the repo on my instance, make changes and then create the PR. Not impossible, but kind of painful and doesn't
help people contribute to my small amount of shitty projects.


I dealt with this for a year but have just recently decided that it just isn't going to work. The whole concept of Github is to create a social site where folks can contribute
code. I like that. I like helping out when I can and I like people sharing cool ideas with me on my code. This wasn't happening for me and my projects are nowhere near
popular enough to force people over to my self-hosted instance. For those reasons I'm actually going to move back to Github as my primary code repo and just use Gitea as kind 
of a mirror. I realize that is a little silly with Git but fuck it, Gitea is already up and running so I might as well use it for something eh?


E-mail was something I touched on previously and as of today, I don't have an answer outside of 3rd party providers. This was probably my 3rd attempt at hosting
my own mail server and sadly, again, it didn't work out. The issue was deliverability and no matter what I tried I couldn't get it to a point where I felt
that my e-mails would reach the recipient(s). Sending to the major e-mail providers was a game of roulette on if my messages would be flagged as spam despite the fact that
I had done everything that they all suggest to do. 


Clean IP? Check. 

DKIM setup? Check. 

SPF? Check. 


I **REALLY** wanted this to work but it just wasn't meant to be. I've decided to just stick with [ProtonMail](https://protonmail.com/) for now :(.


Photo and video sharing was also something I had not setup yet in my previous post but something I was looking into. I ended up setting up [Seafile](https://www.seafile.com/en/home/)
which as a product worked well. I still have some odd issues with the Android client syncing my photos, but I know about it and can use my manual workaround to "fix" it. The bigger
problem was the ability to smoothly play videos which doesn't really land on Seafile. 
Most of my family lives far away from me so videos are something I take a lot of so that the family can see what is going
on in our life. With just a single VM, no CDN and a small internet pipe it was really hard for people to watch the videos because they were constantly buffering. Technically the
video part was working, it just wasn't very usable because of the starts and stops. This was a huge bummer because Seafile itself is pretty cool. For now I'm using it as another
spot to backup all of my data just in case I need to split from Google Photos quickly, but for day-to-day sharing I am still using Google Photos :(.




