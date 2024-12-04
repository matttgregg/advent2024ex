defmodule Advent2024ex.Day4 do
  def file_to_grid(fname) do
    File.read!(fname) |> String.split("\n") |> Enum.map(&String.to_charlist/1)
  end

  defp char_at(grid, r, c) when r >= 0 and c >= 0 do
    row = Enum.at(grid, r, nil)

    if row do
      Enum.at(row, c, nil)
    else
      nil
    end
  end

  defp char_at(_, _, _) do
    nil
  end

  defp match_at?(grid, {ro, co, char}, r, c) do
    char == char_at(grid, r + ro, c + co)
  end

  def pattern_at(grid, pattern, r, c) do
    Enum.all?(pattern, fn p -> match_at?(grid, p, r, c) end)
  end

  def xmas_at(grid, r, c) do
    patterns = [
      [{0, 0, ?X}, {0, 1, ?M}, {0, 2, ?A}, {0, 3, ?S}],
      [{0, 0, ?X}, {0, -1, ?M}, {0, -2, ?A}, {0, -3, ?S}],
      [{0, 0, ?X}, {1, 0, ?M}, {2, 0, ?A}, {3, 0, ?S}],
      [{0, 0, ?X}, {-1, 0, ?M}, {-2, 0, ?A}, {-3, 0, ?S}],
      [{0, 0, ?X}, {1, 1, ?M}, {2, 2, ?A}, {3, 3, ?S}],
      [{0, 0, ?X}, {-1, -1, ?M}, {-2, -2, ?A}, {-3, -3, ?S}],
      [{0, 0, ?X}, {1, -1, ?M}, {2, -2, ?A}, {3, -3, ?S}],
      [{0, 0, ?X}, {-1, 1, ?M}, {-2, 2, ?A}, {-3, 3, ?S}]
    ]

    Enum.count(patterns, fn pattern -> pattern_at(grid, pattern, r, c) end)
  end

  def crossmas_at(grid, r, c) do
    patterns = [
      [{0, 0, ?A}, {1, 1, ?M}, {-1, -1, ?S}, {1, -1, ?M}, {-1, 1, ?S}],
      [{0, 0, ?A}, {1, 1, ?M}, {-1, -1, ?S}, {1, -1, ?S}, {-1, 1, ?M}],
      [{0, 0, ?A}, {1, 1, ?S}, {-1, -1, ?M}, {1, -1, ?M}, {-1, 1, ?S}],
      [{0, 0, ?A}, {1, 1, ?S}, {-1, -1, ?M}, {1, -1, ?S}, {-1, 1, ?M}]
    ]

    Enum.count(patterns, fn pattern -> pattern_at(grid, pattern, r, c) end)
  end

  def scan_for_patterns(fname, matcher) do
    grid = file_to_grid(fname)
    rows = Enum.count(grid)
    cols = Enum.map(grid, fn r -> Enum.count(r) end) |> Enum.max()
    scan_points = for r <- 1..rows, c <- 1..cols, do: {r - 1, c - 1}

    Enum.map(scan_points, fn {r, c} -> matcher.(grid, r, c) end) |> Enum.sum()
  end

  def scan_for_xmas(fname) do
    scan_for_patterns(fname, &xmas_at/3)
  end

  def scan_for_crossmas(fname) do
    scan_for_patterns(fname, &crossmas_at/3)
  end

  def run(test \\ false) do
    fname = if test, do: "./puzzle_data/day4.tst", else: "./puzzle_data/day4"
    part1 = scan_for_xmas(fname)
    part2 = scan_for_crossmas(fname)
    [part1, part2]
  end
end
