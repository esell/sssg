---
title: My adventures in self-hosting
author: crimepigeon
date: March 3, 2017
---

Some people's new years resolution was to lose weight, others was to give themselves more "me" time. Mine was to move off of as much SaaS offerings as I could in an attempt 
to start taking back my privacy.


Don't get me wrong, there are a lot of SaaS solutions out there that are awesome and take away the burden of having to manage a server but I felt that there was just too 
much of my info being spread across these sites. There wasn't a single event that triggered my new goal to move everything to my own infrastructure, it was more that I was 
noticing that every couple of months I felt like I was signing up for new SaaS apps or connecting to a new app via another service I already had an account on. 
I had already closed down my social media accounts, which were probably the ones I had to worry about the most, but wanted to take the next step to independence.




First on my list was this site. I had been thinking of moving it for some time as hosting it on Github pages didn't allow me to use SSL unless I used something like Cloudflare which I didn't want
to do. Most of the big cloud providers have some type of blob storage that works great for static sites, but again, at the time none of them had what I would call acceptable 
SSL support. The solution I ended up going with was a small VM with one of the large cloud providers and setup disk encryption (with my key) to make sure it really was "mine". 
Now I needed a web server. I had been an Apache guy most of my life but that felt too heavy for what I wanted. I had heard of [Caddy](https://caddyserver.com/) and after reading the 
docs it sounded like a perfect fit. It was easy to setup, has support for [Let's Encrypt](https://letsencrypt.org/) out of the box and also has a nifty git plugin that pulls in my static 
site from my git repo whenever the content has changed. It took me about 5 minutes to get things up and running at which point I had one item off of my checklist. Caddy is awesome and as you'll see later, 
it ended up being the hub of most of my solutions.


The next item was how to get off of Github and the random services I had connected into it like TravisCI and Coveralls. The part I struggled with here was the social aspect of it. Not so much stars, watchers, etc but more of the PR and issue management system. Granted I don't have any high-profile repos but at the same time I didn't want to put up a barrier to prevent people from submitting 
something. Asking someone to create a user/pass just for my shitty git repo wasn't an option. As luck would have it, [Gitea](https://gitea.io/en-US/), which is a fork of [Gogs](https://gogs.io/) had just sprung up. Gitea has been much more active with regards to commits and one of those commits just happened to be supporting authentication via Github! I pulled down the source, got it all built 
and dropped it behind my Caddy server, again with it's own fancy Let's Encrypt cert. Is Gitea a bit rough around the edges? Sure, but it covers everything I need and is fairly lightweight, 
easy to setup/maintain and can use sqlite as a backend so I didn't have to manage a database server.


So I had a solution to my git repo hosting, now what about replacing TravisCI and Coveralls? I'm glad you asked! This part of my self-hosting process ended up being a bit more work than I expected.
To replace TravisCI I went with self-hosted [Drone](https://github.com/drone/drone). Drone was pretty easy to get going since it comes as a Docker image so once I had it fired up I simply 
logged in and enabled it for the repos I wanted. The `.drone.yml` file took a bit of work to get working with the native go vendoring system but I eventually got it working. Coveralls was next up on 
the list and surprisingly I didn't find very many open source options. I ended up hacking together [hoptocopter](https://git.esheavyindustries.com/esell/hoptocopter) which actually 
just uses the native go test coverage tooling and then spits out one of those fancy badges via [shields](http://shields.io/). To avoid having to call their API I used the wonderful 
[shields docker image](https://github.com/beevelop/docker-shields) provided by beevelop. From there I just setup a Docker compose file that started up hoptocopter and shields together and bam! 
Instant code coverage badges. At this point I had basically re-created everything I had in Github. There were some things I couldn't implement such as builds being triggered by PRs, but that wasn't 
a huge deal to me so I considered it a success. Guess what I used to front these? If you said Caddy you'd be correct.


Previously this site had used Google Analytics for metrics. I actually like the product and enjoy seeing all of the cool data about my site but Google and privacy do not belong in the same
sentence. My next goal was to rid myself of Google Analytics and find something I could run on my server but that still had an easy to use UI. Enter [GoAccess](https://www.goaccess.io/). 
Really nothing to say about GoAccess outside of it just works. It parses the log files from Caddy and turns them into a pretty html page. This page is served up by... Caddy.


Password management, a great debate topic. Do you use a fancy hosted tool like LastPass or do you use something you can store locally like KeePass? The answer for me was neither, I went with 
[pass](https://www.passwordstore.org/) which is a super simple (good) way to manage your passwords but still be able to access them on most devices including my Android phone. I setup pass to 
use git as a storage location by setting up a private repo on my new Gitea setup. I lost a tiny bit of functionality over something like LastPass, but nothing I couldn't do without. If you
wanted to be super crazy you could use something like [git-remote-gcrypt](https://spwhitton.name/tech/code/git-remote-gcrypt/) to encrypt your actual git repo. Double the encryption, double the fun.



Now I have to talk about the things I haven't come up with a good solution for (yet). The biggest is e-mail. A few years ago I tried hosting my own mail server and did everything the internet 
says to do to avoid your e-mails being flagged as spam. Unfortunately that didn't work and about 80% of my e-mails ended up in the spam folder of my friends and family. I am currently using 
[Protonmail](https://protonmail.com/) which is great and I have no real problems with, it's just that I don't have those messages on my own server so I have to trust that everything 
they say they do is actually true. That's a fairly big thing to do but at this point I just have to suck it up and deal with it.
The second area is image and video sharing. Things like Google Drive or Google Photos are great products but again, Google. I've been looking around for some open source alternatives 
and haven't found anything yet that meets my needs. I want to be able to send photos right from my phone to the app on my server and then send out generated links to family members 
to access those files all while keeping them hidden from everyone else. I've toyed around with hacking something together but I have to believe that an app like this already exists 
so I'll keep searching.


I still have a bit left to do like moving all of my Github repos over to my Gitea setup but so far I've been enjoying the new freedom. Since most of these apps are pretty low 
maintenance I don't really have to do much sysadmin type work which is great. If that will still be the same six months from now I'll just have to wait and see.
