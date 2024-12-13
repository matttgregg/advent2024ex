defmodule Advent2024ex.Day12 do
  @day 12

  alias Advent2024ex.Grid

  def field_around(g, p, crop, found) do
    cond do
      # We've already been here
      MapSet.member?(found, p) ->
        found

      # This is in the same field! Check the neighbours.
      crop == Grid.at11(g, p) ->
        Grid.linear_neighbours(p)
        |> Enum.reduce(
          MapSet.put(found, p),
          fn nbr, new_field ->
            field_around(g, nbr, crop, new_field) |> MapSet.union(new_field)
          end
        )

      # Not a field member
      true ->
        found
    end
  end

  defp perimeter_at(g, p, crop) do
    Grid.linear_neighbours(p) |> Enum.count(&(Grid.at11(g, &1) != crop))
  end

  def cost_of_field(g, field, crop) do
    area = MapSet.size(field)
    perimeter = MapSet.to_list(field) |> Enum.map(&perimeter_at(g, &1, crop)) |> Enum.sum()
    area * perimeter
  end

  def cost_grid({_, rows, cols} = g, costing_fn) do
    all_pts = for r <- 1..rows, c <- 1..cols, do: {r, c}

    {_, total_cost} =
      Enum.reduce(
        all_pts,
        {MapSet.new(), 0},
        fn p, {seen, cost} ->
          if MapSet.member?(seen, p) do
            # Already been here.
            {seen, cost}
          else
            crop = Grid.at11(g, p)
            field = field_around(g, p, crop, MapSet.new())
            field_cost = costing_fn.(g, field, crop)
            {MapSet.union(seen, field), cost + field_cost}
          end
        end
      )

    total_cost
  end

  def bulk_cost(_g, field, _crop) do
    boundaries = [
      {{1, 0}, [{0, 1}, {0, -1}]},
      {{-1, 0}, [{0, 1}, {0, -1}]},
      {{0, 1}, [{1, 0}, {-1, 0}]},
      {{0, -1}, [{1, 0}, {-1, 0}]}
    ]

    total_walls =
      Enum.map(
        boundaries,
        fn {exterior, dirs} -> field_walls_boundary(exterior, dirs, field) end
      )
      |> Enum.sum()

    total_walls * MapSet.size(field)
  end

  defp field_walls_boundary(exterior, dirs, field) do
    {count, _} =
      MapSet.to_list(field)
      |> Enum.reduce(
        {0, MapSet.new()},
        fn p, {count, seen} ->
          wall = wall_from(p, exterior, dirs, field, MapSet.new(), seen)
          new_count = count + if MapSet.size(wall) > 0, do: 1, else: 0
          new_seen = MapSet.union(seen, wall)
          {new_count, new_seen}
        end
      )

    count
  end

  defp pplus({ra, ca}, {rb, cb}) do
    {ra + rb, ca + cb}
  end

  def wall_from(p, exterior, dirs, field, wall, seen) do
    cond do
      # Not in the field
      !MapSet.member?(field, p) ->
        wall

      # Already been here
      MapSet.member?(seen, p) || MapSet.member?(wall, p) ->
        wall

      # Not on the edge
      MapSet.member?(field, pplus(p, exterior)) ->
        wall

      true ->
        # We're in the field and on the edge. Try the neighbours too.
        Enum.reduce(
          dirs,
          MapSet.put(wall, p),
          fn dir, acc ->
            wall_from(pplus(p, dir), exterior, [dir], field, acc, seen)
          end
        )
    end
  end

  def run(test \\ false) do
    grid = Advent2024ex.file_for(@day, test) |> Grid.load_grid()
    part1 = cost_grid(grid, &cost_of_field/3)
    part2 = cost_grid(grid, &bulk_cost/3)
    [part1, part2]
  end
end
