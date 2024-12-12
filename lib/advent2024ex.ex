defmodule Advent2024ex do
  @moduledoc """
  Advent2024ex keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def run_all do
    all_tests = %{
      1 => &Advent2024ex.Day1.run/0,
      2 => &Advent2024ex.Day2.run/0,
      3 => &Advent2024ex.Day3.run/0,
      4 => &Advent2024ex.Day4.run/0,
      5 => &Advent2024ex.Day5.run/0,
      6 => &Advent2024ex.Day6.run/0,
      7 => &Advent2024ex.Day7.run/0,
      8 => &Advent2024ex.Day8.run/0,
      9 => &Advent2024ex.Day9.run/0,
      10 => &Advent2024ex.Day10.run/0,
      11 => &Advent2024ex.Day11.run/0,
      12 => &Advent2024ex.Day12.run/0
    }

    all_start = Time.utc_now()

    for i <- Map.keys(all_tests) do
      test = Map.get(all_tests, i)
      tstart = Time.utc_now()
      result = test.()
      tend = Time.utc_now()

      IO.puts(
        "Day #{i} : #{Enum.join(result, " and ")} (#{Time.diff(tend, tstart, :millisecond)} ms)"
      )
    end

    all_end = Time.utc_now()
    IO.puts("Completed in #{Time.diff(all_end, all_start, :millisecond)} ms")
  end

  def file_for(day, test \\ false) do
    "./puzzle_data/day#{day}#{if test, do: ".tst"}"
  end
end
