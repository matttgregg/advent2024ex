defmodule Advent2024ex do
  @moduledoc """
  Advent2024ex keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def run_all do
    run_and_puts(1, &Advent2024ex.Day1.run/0)
    run_and_puts(2, &Advent2024ex.Day2.run/0)
    run_and_puts(3, &Advent2024ex.Day3.run/0)
  end

  defp run_and_puts(day, f) do
    IO.puts("Day#{day} : #{Enum.join(f.(), " and ")}")
  end
end
