# Advent2024ex

[Advent of Code](adventofcode.com) implemented in Elixir/Phoenix

# Intro

So this year, working in Elixir/Phoenix, for a few reasons. This might
seem a little odd, as this type of challenge isn't necessarily a natural fit, or
at least the lnaguage features that make Elixir interesting aren't likely to 
be shown off in Advent of Code. For example reliable concurrency and resilience.

This probably goes twice for Phoenix - there's absolutely no need for a web server
component to advent of code puzzles. So here's my brief thinking:

* It's the language that I'm currently working on in my spare time as I work a bit more on 
  full stack web projects.
* It *does* allow experimentation with the very clean Elixir syntax and ecosystem.
* It's not a speed powerhouse - but that's not a problem for advent of code.
* Embedding it in a Phoenix app is largely free. (I'm not giving it to others, bloat isn't a concern.)
* I'd like the *option* to experiment with Phoenix as I progress - maybe opportunities will come up, maybe not.

So, all in all doing Advent of Code in Elixir/Phoenix will help with going over fundamentals and
leave the door open to some interesting extensions if I feel like it.

Maybe one foreshadowing comment - I haven't used any parser libraries in Elixir and don't even know the
standard libraries. I anticipate at least one day blazing through parser library documentation to 
get something working quickly.

If I was absolutely looking to do the puzzles as quickly as possible in Elixir, I'd probably be looking at
LiveBook - maybe I will end up doing some in LiveBook, it's a great technology!

# [Day 1](https://adventofcode.com/2024/day/1)

As expected, things start of relatively simple with some basic text processing.

Know how to read a file, split it up, parse as integers. It's simple, but it's also multi-stepped
and there's just enough here to make you think a little about how you chunk up those functions and
assemble them.

I'm not super keen on my solution to be honest - the naming isn't great, and the divisions are a bit
messy. But, it's definitely good enough for a small run through like this.

The second part is similar. What I do find interesting after you've worked in a few languages is that
you get a bit of a sense for what standard library functions you can reasonably expect and where you might
find them. The Elixir libraries and documentation are particularly pleasantly organised, so no problems
so far.

So - puzzle solved, onto the next star.

# [Day 2](https://adventofcode.com/2024/day/2)

Slightly more fiddly today. Again the problem input is quite straightforward but the verfications
are a little bit more involved.

I used zipped lists for the processing - I'm not sure if that counts as a trick, but it's definitely
a pattern that comes up in functional programming. 

For part 2, slightly more interesting and some benefits in keeping the code a little organised. Although 
everything is still tiny. Some interest in how you keep the various combinations straight in your head
and how you model - definitely multiple otpions.

Again, I'm not reaching for absolute speed, just a functionally correct version. 
I'm seeing quite a few shortcuts that could be applied 
at a low level, but it's not worth it a this level and for the size of the inputs. As far as a human can tell these solutions are
instantaneous. Running through a list four or five times is acceptable.

Interestingly I am already seeing bits and pieces that I might re-use over multiple days, and may factor out when
time allows.

# [Day 3](https://adventofcode.com/2024/day/3)

Still on the slight upwards difficulty curve.

I quite like these pseudo-language type problems, although this one is abolutely the minimal version of this. I do mean
to go back and do the intcode year fully at some point (I bailed about halfway through at the time as my interpreter became 
unwieldy). Having gone through a bit of language design and even peeked into
assembly, I've got a much better appreciation of that year now!

Anyway, this day, interestingly, it's explixitly about finding patterns in junk text, so this is a day when I feel regex are
the absolutely perfect tool here. The patterns are small and simple, so it works really well. I think was actually my fastest and
shortest part one day so far, but partly because I've got my framework and basic tools set up now.

Part 2 was fun, nicely makes the things a bit more complex but not too complex. Shout out to the Elixir `IO.inspect` function
which allows for delightfully easy debugging of pipelines. This allowed me to instantly catch a little bug that I had with
overlapping patterns.

How to process 'these sorts of things'? I went for an ad-hoc stateful fold, which is direct and sould be efficient. I'm intrigued
to look at other peoples solutions and see if there are more idiomatic ways of expressing the same idea.

I'm also intrigued by how I'd do it in a streaming fashion. Absolutely not worthwhile in this puzzle, but would be interesting
to do the whole problem in a single pass. That might be a bit more of a (simple) purpose built parser. Completely unnecessary for
the puzzle solution, but might be interesting to code up if I have time.

# [Day 4](https://adventofcode.com/2024/day/4)

A fun one today - some [non-trivial text scanning](https://adventofcode.com/2024/day/4).

Firstly the good news - I decided to implement as a generic pattern matcher which I then applied
across the grid of text. As a result, when the pattern to match changed in part 2 it was really, really easy to update.

On the flip side, I completely forgot that the Elixir `List.get` function uses wraparound - i.e. `get(-1)` will
get values from the *end* of the list. This is one of those features that is incredibly helpful a lot of the time, but will
trip you up sometimes. Just one for me to be aware of, and remember for next time.

As a result the chacks around the edge of the grid were wrappping around. (Word-search
on a torus? Not going to catch on.) I am eternally grateful that the test case Eric provided this, and as a result was 
able to scratch my head on an 19 versus 18 on the example, rather than on an unknwown error on several thousand. Thank you, 
thank you, thank you for festive gifts.
Given that I was wrapping my index lookups anyway (to avoid out of range at the top end), it was easy to correct.

# [Day 5](https://adventofcode.com/2024/day/5)

I enjoyed this one, maybe more than I should have. Some intersting [verification and sorting](https://adventofcode.com/2024/day/5).

This one mostly boiled down to picking the right data structures, and not being too lazy - i.e. not
just stuffing everything into lists. How slow would things be if just in lists? I'm not sure, maybe not
unworkably slow given we're on day 5, but certainly not optimal.

It's also one of those situations where it pays to be smart about the data structure, and not just take the data structure in
the input. Here, the orders are all supplied as `a<b` - but in fact, depending on how you traverse the data, it can be more
efficient to store as `b<a`. (Or at least use the `b`'s as the keys.) Either way there's a little bit of work to marry up
your data strucutures with the algorithms. In larger scale projects I'd probably also be thinking about how representations
interact - what's the 'canoncial' representation (if there is one), what's the scope of representations. (I've been burnt a few times!)
This is however Advent of Code, so not something to worry about here.

I did have an initial bug around treating a Map/Set as a list, which I needed some debug to catch. Agreed, a strongly typed language
would probably have caught this, but it's often swings and roundabouts with type systems, so I didn't feel too aggrieved.

Meanwhile, part 2 was again fairly quick because of the neatly structured code. It would definitely be painful in some languages
but most modern languages allow sorts with custom comparisons, so this felt more a question of understanding your standard library
and using it effectively. (However tempting it is to write a sort function from scratch.)

# [Day 6](https://adventofcode.com/2024/day/6)

Today we hit the first of [simulate an agent with rules](https://adventofcode.com/2024/day/6) type puzzle. Or evolving system
as it breaks down to. In later days this can be a lot more complex, with complex evolution rules - e.g. for maybe multiple agents, but
as we're still in single figure days the evolution is fairly simple.

This type of thing is largely about keeping the rules straight, simple, and testing as much as possible. Particularly in the more naive
step-by-step implementations - which I used.
The second part of the puzzle is very interesting, as we now need to try adding obstacles into the map. The only (slightly) smart thing 
I did was to only add obstacles to the guards path - they're the only one that will matter - rather than add obstacles all over the map.
Keeping track of the path is one way of tracking loops.

My final solution  - is OK. It runs in under 10 seconds. My hunch is that the best performance improvement would be to use
mutable arrays, rather than relying on hash maps. That's not quite so natural in Elixir, but I'd probably try in Rust or C or go.

So, calling it here - off to look at others solutions to see if there are smart algorithms!

Edit 1:
OK, ended up doing a fair few tweaks to pull down the timing of part 2. Mainly covered:
* Precalculate as much as possible, avoid any unnecessary lookups. This covers the bounds, the guard char (never use the char again, use coord offsets directly).
* Update as little as possible. No need to update the map itself (with Xs), just track exactly what's needed like the path turning and turn points.
* Don't use lists - use a hash map for coordinate tiles.
* Do the experimental obstacle placements while walking the initial path - this avoids each test path starting from scratch again.

I also put in some basic timing output in my full run. With all this done I'm now completing the first 6 days in under 0.4 seconds. (Although almost all of that time is spent in Day 6.) This seems perfectly reasonable with people describing C, and Rust solutions running in tenths of a second. I think, probably the biggest improvement would be to use an array type data structure rather than hash-map or list lookups, but I think I'm probably scraping the barrel on Elixir solutions at this point. The tweaks are all in the sane but practical lavel with decent payoff, and if I can get the whole 24 puzzle set running in under a second I'll be quite happy.

# [Day 7](https://adventofcode.com/2024/day/7)

This was interesting, a mixture of things we've seen [non-standard string processing and potentially large search space](https://adventofcode.com/2024/day/7). 

To be honest, I found this simpler than yesterday, my only real slip was not reading the question properly and only *counting* the 
lines that worked, rather than summing the target values. Otherwise, once fixed everything worked first time.

A few things that I worried could have come up but didn't - one was that the test space would become too large too quickly. The other
was that there would be integer overflows. However, I noticed that calculations always get bigger - as a result, it's very easy to
ditch calculation paths which might get too big early. I'm not sure if this saved me from both of those potential problems.
Update: I checked - no real problem. Slightly slower (fractions of a second) but nothing significant. BUT (optimised or not) I would be failing if using 32 bit integers. It looks like Elixir automatically defaults to arbitirary precision integers, and so 

Today was nice, fitted in with some things that I knew, and didn't take me too long - which was lucky as I was travelling today. For people
having problems, I guess I'd say to  try and keep things simple on this one, and worry about integer limits if necessary.

# [Day 8](https://adventofcode.com/2024/day/8)

[More grids!](https://adventofcode.com/2024/day/8) But this time more geometric processing than time evolution.

Today felt like a very neat 'keep everything organised, don't confuse yourself' type problem. I broke it neatly into:

* Read the data, work out the bounds.
* Work out all the antennae, store by 'frequency'.
* For each frequency of antennae, for each pair work out all the node points.
* Sort node points, drop any out of range, pick unique ones.

And then part 2 is changing your node function - using an anonymous function Elixir makes it very pleasant just to swap in
a different function depending on the day. Yes there's a double loop, but you genuinely need to collect all of those points.

Things to watch for - off by one errors, getting mixed up, sub-optimal data structures. The geometry for calculating the points
is a bit fiddly - if you've seen it before it's fairly quick to know what sort of thing this will look like, otherwise it's a bit of a 
pencil and paper job. Same with working out how to count 'just enough' nodes in the second part. (I'll admit, I actually fudged it here
and probably went a little outside the grid - but I'm filtering those out afterwards anyway.)

Updated my global runner to get more timing data on each day individually - currently Day 7 is topping out for me at about a third of 
a second. The first eight days coming in at about 0.8 seconds. Not amazing, but perfectly fine in Elixir withoug excess tuning.

Intriguingly the reddit community points out that you can drastically improve Day 7 by working backwards - the reason being that 
you know that you have to always have an integer value, so the places where a 'divide' is a valid operation (or `un-||`) are a lot rarer, and as a result the explorable potential-operators space is cut down a lot quicker. I haven't just done it because I can see there's a little fiddliness in inverting the operators properly. I may try if I have time.

We're a third of the way through AoC!

# [Day 9](https://adventofcode.com/2024/day/9)

It _seems_ simple - but [this was the first problem](https://adventofcode.com/2024/day/9) that I had to walk away from and come back t later. Annoyingly I'm not 100% sure what my original bug was or how I fixed, which problems inidcates over complication somewhere.

The first part was fine - there's a lot to keep track of, but a simple walk from front to back pays off quickly and neatly. However:

* This really didn't work well for part 2. While for pat 1 I was consuming spaces as I found them, in part 2 you don't know what's going to fill the space - it might not be from the back. As a result, I reused very little code, besides simple parsing.
* Still tried to do in a forward pass initially - still didn't work as it's essential moves are tried with maximum magnitude first.
* Didn't have optmised data structures, so my part 2 was running in seconds rather than milliseconds. I decided I could live with it until I got a correct answer.
* Got the wrong answer on test data, realised I wasn't leaving a gap when I moved data.
* Realised I was sometimes pushing data *later* on the disk.
* Finally got the right answer to test data, but too low for actual data.
* Fiddled with debug, but didn't see anything obvious.
* Went down a rabbit hole of ensuring I combined neighbouring spaces, deleted 'empty' spaces - but it doesn't really matter.
* Went through various refactorings to see what broke and gave me ideas - nothing really.
* Went on reddit, seemed to have escaped all the corner cases people were highlighting. (Moving blocks twice, etc.)
* Noticed that my test answer was still right, but the solution was *slightly* different. Plugged it in and passed!

So, overally not a great day - I think the strategy was fine, but obviously got a bit snow blind at some point. Annoyingly no blinding insights on what went wrong!

Either way, these were mainly my problems. The puzzle itself was quite interesting with enough fiddly details that it was non-trivial. Fingers crossed I'm a bit more awake tomorrow!

# [Day 10](https://adventofcode.com/2024/day/10)

From the ridiuculous to the sublime! Wheras yesterday was a nightmare of hidden bugs and (my) confusing code, today was fast and clear.
I'll say to start with that I'm really fond of path finding algorithms - they're meaningful, interesting, fascinating and just generally fun to play with. This problem was therefore right in my comfort zone. I even spent the time re-using some of my grid code in a library, and writing it to use Elixir binaries for speed and neatness. As a result the code was really short (by my standards) and efficient. Both parts for me are running in ~2ms which is among my fastest days. Only minior hiccups were using the wrong day's data as input at first (d'oh) and then forgetting to convert from binary representation to a numerical digit.

The second part flowed from the first, and when using a recrusive approach amounts to collecting the path as well as the end point. There's even no annoying uniqueness checks if you build paths such that every path found is unique!

Overall, a really nice day to code up and play with. Also one that lends itself to visualizations - I may play if given time.

I do pity the poor hikers who's only options are trails straight up to the tops of mountains - no easy flat ciruits!

Update: Realised after that even for part 2, I still don't need to collect the paths. It's fun for debug/visualizations, but not a requirement given that they're all unique by construction.

# [Day 11](https://adventofcode.com/2024/day/11)

Another really fun day! This one is mainly about caching data properly. Despite a lot of 'yay, brute force' on line for previous days, this
feels the first day where *brute force* has actual meaning here. In this case the naive (brute force) approach of just generating the stone pattern fails completely. 

After a while you recognise that these sorts of production rules tend to grow exponentially. AoC is very fond in that case of a *Part 1* at a level where you could probably just about do it brute force, and then *Part 2* is 'Oh, actually the elves want to run it for 5 times longer' - and suddenly it's practically impossibly to naively just create the whole list - both in terms of memory and time.

So, on reading I just didn't bother doing an uncached version, and could run parts 1&2 off the same code. If you know the caching techniques it's not much extra work, and it's definitely a problem that needs it, even in part 1.

My main excitement today was implementing my cache as an OTP Genserver - which was surprisingly painless. It was good practice, but it feels like once you've done a few iterations GenServer is a really easy pattern to follow. I *did* have a little diversion thinking about caching the list parts as well as the lengths reached - but it started getting fiddly, and I decided that just lengths was probably enough. I ran it with just lengths and it was completely fine.

Maybe some smarter caching could squeeze out a bit more performance - my run is currently running around the 0.5s mark - but I'm not sure the payoff is worth it. (Just for kicks, I turned of caching to see what happened, and unsurprisingly my laptop ground to a halt.)

# [Day 12](https://adventofcode.com/2024/day/12)

Moving from something heavily based on efficiency to something much more geometric. I always find it interesting how to apply what's essentially a path finding algorithm to a non-obvious space. In this case, finding connected sets, finding contiguous edges to an area.

I'm glad that the problem included disjoint fields with the same tag - that makes things a lot more interesting. The edge finding in part two was interesting and non-trivial to implement. It was however pleasantly orthogonal - allowed the re-use of the area finding code, and full replacement of the costing function.

For my part, despite enjoying the problem I managed to bury a rather stupid error. In my code for building walls, I built walls for each point in a field, keeping track of anything already seen in the field do that I don't double count. Unfortunately I failed to differentiate between the fact that I wanted to track additions to the current wall, and 'seen' things that I'd already considered from a different wall point. (I needed both because I wanted to know whether, for a particular direction, I could build a non-empty wall from a point that I hadn't seen before.) Easily spent half an hour in detailed debug tracking the different sets before I realised the problem, and then fixed to track these properly. However, once done th idea worked fine and two more stars were ticked off!

A few other observations:
* The `Grid` library I factored out earlier in the month was useful again, and saved a lot of tedious code.
* Remembered to use reductions (folds)! (The Genserver yesterday was fun, but unnecessary.)
* No real performance problems today, it's more a 'get the logic right' type of day.

# [Day 13](https://adventofcode.com/2024/day/13)

This one was completely within my comfort zone, but I appreciate completely people who dislike leetcode problems (and leetcode programming interviews) for this sort of problem.

It completely hinges on whether you're comfortable with solving simultaneous equations. If you *are* then it's likely you'll never even bother trying a brute force 'try lots of solutions' type approach - it's the sort of thing that **if you study maths** you'll do with paper and pencil and hardly even think of using a computer. If not... it's a lot more work to get there from scratch. Much like day 11, the first part was probably just about doable with a full search, but part 2 just pushes the numbers up and an analytic solution becomes essential.

So, my case, because of my background I just solved analytically and the second part was trivial. Also reaped the benefit of Elixir having unbounded integers, so was trivial.

I also enjoyed the callback to the hotel tiled floor - this was the last year that I completed fully, I remember the problem being a fun gamep-of-life type puzzle and getting upstairs to the hotel room being the end of the year!

# Standard Phoenix README follows...

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
