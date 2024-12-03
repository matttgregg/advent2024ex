defmodule Advent2024ex.Day3 do
  def match_mult(text) do
    Regex.scan(~r{mul\((\d+),(\d+)\)}, text)
    |> Enum.map(fn [_match, d1, d2] -> String.to_integer(d1) * String.to_integer(d2) end)
    |> Enum.sum()
  end

  def match_mult_enabled(text) do
    Regex.scan(~r{mul\((\d+),(\d+)\)|don't|do}, text)
    |> accumulate_mult(true, 0)
  end

  defp accumulate_mult([next | rest], enabled, acc) do
    {n_enabled, n_acc} =
      case next do
        ["don't"] ->
          {false, acc}

        ["do"] ->
          {true, acc}

        [_match, d1, d2] ->
          if enabled do
            {true, acc + String.to_integer(d1) * String.to_integer(d2)}
          else
            {false, acc}
          end
      end

    accumulate_mult(rest, n_enabled, n_acc)
  end

  defp accumulate_mult([], _enabled, acc) do
    acc
  end

  def run(test \\ false) do
    fname = if test, do: "./puzzle_data/day3.tst", else: "./puzzle_data/day3"
    part1 = File.read!(fname) |> match_mult()
    fname = if test, do: "./puzzle_data/day3.2.tst", else: "./puzzle_data/day3"
    part2 = File.read!(fname) |> match_mult_enabled()
    [part1, part2]
  end
end
