defmodule Advent2024ex.Day7 do
  def parse_line(line) do
    [t, ps] = String.split(line, ": ")
    target = String.to_integer(t)
    parts = String.split(ps) |> Enum.map(&String.to_integer/1)
    {target, parts}
  end

  def makes_target(target, curr, [], _) do
    target == curr
  end

  def makes_target(target, curr, _, _) when curr > target do
    false
  end

  def makes_target(target, 0, [h | rest], conc) do
    makes_target(target, h, rest, conc)
  end

  def makes_target(target, curr, [h | rest], conc) do
    if conc do
      makes_target(target, curr * h, rest, conc) || makes_target(target, curr + h, rest, conc) ||
        makes_target(target, conc_values(curr, h), rest, conc)
    else
      makes_target(target, curr * h, rest, conc) || makes_target(target, curr + h, rest, conc)
    end
  end

  def sum_of_target(target, ps, conc) do
    if makes_target(target, 0, ps, conc) do
      target
    else
      0
    end
  end

  defp conc_values(a, b) do
    String.to_integer("#{a}#{b}")
  end

  def find_good_lines(fname, conc) do
    File.read!(fname)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.map(fn {t, ps} -> sum_of_target(t, ps, conc) end)
    |> Enum.sum()
  end

  def run(test \\ false) do
    fname = if test, do: "./puzzle_data/day7.tst", else: "./puzzle_data/day7"
    part1 = find_good_lines(fname, false)
    part2 = find_good_lines(fname, true)

    [part1, part2]
  end
end
