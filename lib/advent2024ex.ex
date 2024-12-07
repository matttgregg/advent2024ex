defmodule Advent2024ex do
  @moduledoc """
  Advent2024ex keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def run_all do
    tstart = Time.utc_now()
    run_and_puts(1, &Advent2024ex.Day1.run/0)
    run_and_puts(2, &Advent2024ex.Day2.run/0)
    run_and_puts(3, &Advent2024ex.Day3.run/0)
    run_and_puts(4, &Advent2024ex.Day4.run/0)
    run_and_puts(5, &Advent2024ex.Day5.run/0)
    run_and_puts(6, &Advent2024ex.Day6.run/0)
    tend = Time.utc_now()
    IO.puts("Completed in #{Time.diff(tend, tstart, :millisecond)} ms")
  end

  defp run_and_puts(day, f) do
    IO.puts("Day#{day} : #{Enum.join(f.(), " and ")}")
  end
end
