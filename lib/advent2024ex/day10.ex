defmodule Advent2024ex.Day10 do
  alias Advent2024ex.Grid

  @day 10

  def find_path_heads(g, {r, c} = p, i, route) do
    # We are *at* {r, c} looking for value i
    val = Grid.digit_at11(g, p)

    cond do
      val == 9 && i == 9 ->
        # We're at the head!
        [[p | route]]

      val != i ->
        # Not a useful value.
        []

      val == i ->
        # This is wahat we expected! Now look around neighbours for the next value
        Grid.linear_neighbours({r, c})
        |> Enum.flat_map(&find_path_heads(g, &1, i + 1, [p | route]))
    end
  end

  def trailheads_score_for(g, p, :by_end) do
    # Find all potential paths from this point
    # For this scoring mode, we just look at the end point.
    find_path_heads(g, p, 0, [])
    |> Enum.map(&List.first/1)
    |> Enum.uniq()
    |> Enum.count()
  end

  def trailheads_score_for(g, p, :by_path) do
    # Find all potential paths from this point
    # For this scoring mode, we just look at the end point.
    find_path_heads(g, p, 0, [])
    |> Enum.count()
  end

  def all_trails(g, method) do
    Grid.each_coord(g, &trailheads_score_for(&1, &2, method)) |> Enum.sum()
  end

  def run(test \\ false) do
    fname = Advent2024ex.file_for(@day, test)
    part1 = Grid.load_grid(fname) |> all_trails(:by_end)
    part2 = Grid.load_grid(fname) |> all_trails(:by_path)
    [part1, part2]
  end
end
