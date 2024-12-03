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
