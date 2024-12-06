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

# Day 1

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

# Day 2

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

# Day 3

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

# Day 4

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

# Day 5

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

# Day 6

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
