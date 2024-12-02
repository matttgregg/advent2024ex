defmodule Advent2024Ex.Day1 do
  defp file_lines(fname) do
    File.read!(fname) |> String.split("\n") |> Enum.map(&String.split(&1))
  end

  defp first([a, _b]) do
    String.to_integer(a)
  end

  defp second([_a, b]) do
    String.to_integer(b)
  end

  defp diff({a, b}) do
    if a > b do
      a - b
    else
      b - a
    end
  end

  defp numbers_sorted(file_lines, selector) do
    file_lines |> Enum.map(selector) |> Enum.sort()
  end

  def numbers_diffs(fname) do
    file_lines = file_lines(fname)

    Enum.zip(numbers_sorted(file_lines, &first(&1)), numbers_sorted(file_lines, &second(&1)))
    |> Enum.map(&diff(&1))
    |> Enum.sum()
  end

  defp similarity(num, compare_list) do
    Enum.count(compare_list, &(&1 == num))
  end

  def numbers_similarity(fname) do
    file_lines = file_lines(fname)

    compare_list = numbers_sorted(file_lines, &second(&1))

    numbers_sorted(file_lines, &first(&1))
    |> Enum.map(&(&1 * similarity(&1, compare_list)))
    |> Enum.sum()
  end

  def run(test \\ false) do
    fname = if test, do: "./puzzle_data/day1.tst", else: "./puzzle_data/day1"
    part1 = numbers_diffs(fname)
    part2 = numbers_similarity(fname)
    [part1, part2]
  end
end
