defmodule Advent2024ex.Day2 do
  defp safe_pair({a, b}) do
    if a > b do
      if a - b >= 1 && a - b <= 3, do: 1, else: 0
    else
      if b - a >= 1 && b - a <= 3, do: -1, else: 0
    end
  end

  defp safe_nums(nums) do
    safe_pairs = Enum.zip(nums, Enum.drop(nums, 1)) |> Enum.map(&safe_pair/1)
    abs(Enum.sum(safe_pairs)) == Enum.count(safe_pairs)
  end

  def safe(line) do
    String.split(line) |> Enum.map(&String.to_integer/1) |> safe_nums()
  end

  defp safe_skipping(nums, damp_index) do
    List.delete_at(nums, damp_index) |> safe_nums()
  end

  def safe_damping(line) do
    nums = String.split(line) |> Enum.map(&String.to_integer/1)

    if safe_nums(nums) do
      true
    else
      Enum.any?(0..(Enum.count(nums) - 1), &safe_skipping(nums, &1))
    end
  end

  defp file_lines(fname) do
    File.read!(fname) |> String.split("\n")
  end

  def safe_lines(fname) do
    file_lines(fname) |> Enum.count(&safe/1)
  end

  def safe_lines_damping(fname) do
    file_lines(fname) |> Enum.count(&safe_damping/1)
  end

  def run(test \\ false) do
    fname = if test, do: "./puzzle_data/day2.tst", else: "./puzzle_data/day2"
    part1 = safe_lines(fname)
    part2 = safe_lines_damping(fname)
    [part1, part2]
  end
end
