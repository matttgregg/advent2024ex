defmodule Advent2024ex.Day15 do
  alias Advent2024ex.Grid

  def from_text(txt, double \\ false) do
    # Split on an empty line.
    [map, instrs] = String.split(txt, "\n\n")
    g = Grid.from_text(map)

    if double do
      {grid, rows, cols} = g

      new_grid =
        String.replace(grid, ".", "..")
        |> String.replace("#", "##")
        |> String.replace("O", "[]")
        |> String.replace("@", "@.")

      new_g = {new_grid, rows, cols * 2}
      {new_g, Grid.find(new_g, ?@), String.to_charlist(instrs)}
    else
      {g, Grid.find(g, ?@), String.to_charlist(instrs)}
    end
  end

  def move_grid(g, robot, b) when is_binary(b) do
    move_grid(g, robot, String.to_charlist(b))
  end

  def move_grid(g, _robot, []) do
    g
  end

  def move_grid(g, robot, [dir | rest]) do
    {new_grid, new_robot} =
      case dir do
        ?< -> step_grid(g, robot, {0, -1})
        ?> -> step_grid(g, robot, {0, 1})
        ?^ -> step_grid(g, robot, {-1, 0})
        ?v -> step_grid(g, robot, {1, 0})
        # Ignore unexpected input
        _ -> {g, robot}
      end

    move_grid(new_grid, new_robot, rest)
  end

  def move_grid_double(g, robot, b) when is_binary(b) do
    move_grid_double(g, robot, String.to_charlist(b))
  end

  def move_grid_double(g, _robot, []) do
    g
  end

  def move_grid_double(g, robot, [dir | rest]) do
    {new_grid, new_robot} =
      case dir do
        # Left and right are unchanged
        ?< -> step_grid(g, robot, {0, -1})
        ?> -> step_grid(g, robot, {0, 1})
        ?^ -> try_shift(g, robot, {-1, 0})
        ?v -> try_shift(g, robot, {1, 0})
        # Ignore unexpected input
        _ -> {g, robot}
      end

    # IO.puts("->")
    # Grid.as_text(new_grid) |> IO.puts()
    # IO.puts("Moved")
    move_grid_double(new_grid, new_robot, rest)
  end

  def try_shift(g, robot, dir) do
    if shift = to_shift(g, robot, MapSet.new([robot]), dir) do
      {do_shift(g, shift, dir), pt_plus(robot, dir)}
    else
      {g, robot}
    end
  end

  defp pt_plus({a, b}, {c, d}), do: {a + c, b + d}

  def to_shift(_g, _pt, nil, _dir) do
    nil
  end

  def to_shift(g, pt, collected, dir) do
    checking = pt_plus(pt, dir)

    case Grid.at11!(g, checking) do
      # We can 't do this move
      ?# ->
        nil

      # We can do this move, nothing to add
      ?. ->
        collected

      # Left side. Need to add this and the rest of the box, then check above
      ?[ ->
        rest_of_box = pt_plus(checking, {0, 1})
        with_box = MapSet.put(collected, checking) |> MapSet.put(rest_of_box)
        shift_on_left = to_shift(g, checking, with_box, dir)
        shift_on_right = to_shift(g, rest_of_box, with_box, dir)

        case {shift_on_left, shift_on_right} do
          {nil, _} -> nil
          {_, nil} -> nil
          {l, r} -> MapSet.union(l, r)
        end

      # Left side. Need to add this and the rest of the box, then check above
      ?] ->
        rest_of_box = pt_plus(checking, {0, -1})
        with_box = MapSet.put(collected, checking) |> MapSet.put(rest_of_box)
        shift_on_right = to_shift(g, checking, with_box, dir)
        shift_on_left = to_shift(g, rest_of_box, with_box, dir)

        case {shift_on_left, shift_on_right} do
          {nil, _} -> nil
          {_, nil} -> nil
          {l, r} -> MapSet.union(l, r)
        end
    end
  end

  def do_shift(g, collected, dir) do
    new_vals =
      MapSet.to_list(collected)
      |> Enum.map(fn coord -> {pt_plus(coord, dir), Grid.at11!(g, coord)} end)

    # Blank the old values.
    blanked =
      MapSet.to_list(collected)
      |> Enum.reduce(g, &Grid.put11!(&2, &1, ?.))

    # Insert the new vals
    Enum.reduce(new_vals, blanked, fn {coord, val}, acc -> Grid.put11!(acc, coord, val) end)
  end

  def step_grid({_, rows, cols} = g, {rrow, rcol} = robot, {rd, cd} = dir) do
    # Find the steps to the edge

    steps =
      case dir do
        {0, 1} -> cols - rcol
        {0, -1} -> cols - 1
        {1, 0} -> rows - rrow
        {-1, 0} -> rows - 1
      end

    # Find the first which is a gap
    first_gap =
      for i <- 1..steps do
        {i, {rrow + rd * i, rcol + cd * i}}
      end
      |> Enum.find(fn {_, coord} -> Grid.at11(g, coord) == ?. end)

    first_wall =
      for i <- 1..steps do
        {i, {rrow + rd * i, rcol + cd * i}}
      end
      |> Enum.find(fn {_, coord} -> Grid.at11(g, coord) == ?# end)

    case {first_gap, first_wall} do
      {nil, _} ->
        # The grid is unchanged, because there's no gap.
        {g, robot}

      {{to_gap, _}, {to_wall, _}} when to_gap > to_wall ->
        # There is a gap, but it's behind a wall
        {g, robot}

      {{to_gap, _}, _} ->
        # We move everything one step into the gap.
        new_grid =
          for i <- 1..to_gap do
            val = Grid.at11!(g, {rrow + (i - 1) * rd, rcol + (i - 1) * cd})
            {val, {rrow + i * rd, rcol + i * cd}}
          end
          |> Enum.reduce(g, fn {val, coord}, acc -> Grid.put11!(acc, coord, val) end)
          |> Grid.put11!(robot, ?.)

        new_robot = {rrow + rd, rcol + cd}
        {new_grid, new_robot}
    end
  end

  def cost_grid(g) do
    Grid.each_coord(g, fn g, {r, c} ->
      case Grid.at11!(g, {r, c}) do
        ?O -> 100 * (r - 1) + (c - 1)
        ?[ -> 100 * (r - 1) + (c - 1)
        _ -> 0
      end
    end)
    |> Enum.sum()
  end

  @day 15

  def run(test \\ false) do
    data = Advent2024ex.file_for(@day, test) |> File.read!()
    {g, robot, instrs} = from_text(data)
    part1 = move_grid(g, robot, instrs) |> cost_grid()
    {g2, robot2, instrs2} = from_text(data, true)
    part2 = move_grid_double(g2, robot2, instrs2) |> cost_grid()
    [part1, part2]
  end

  def run_small() do
    data = File.read!("./puzzle_data/day15.2.tst")
    {g, robot, instrs} = from_text(data)
    IO.puts("Initial")
    Grid.as_text(g) |> IO.puts()
    move_grid(g, robot, instrs) |> Grid.as_text() |> IO.puts()
    move_grid(g, robot, instrs) |> cost_grid() |> IO.puts()

    {g, robot, instrs} = from_text(data, true)
    IO.puts("Initial, double")
    Grid.as_text(g) |> IO.puts()
    move_grid_double(g, robot, instrs) |> Grid.as_text() |> IO.puts()
    move_grid_double(g, robot, instrs) |> cost_grid() |> IO.puts()
  end

  def run_small2() do
    data = File.read!("./puzzle_data/day15.3.tst")
    {g, robot, instrs} = from_text(data, true)
    IO.puts("Initial")
    Grid.as_text(g) |> IO.puts()
    move_grid_double(g, robot, instrs) |> Grid.as_text() |> IO.puts()
    move_grid_double(g, robot, instrs) |> cost_grid() |> IO.puts()
  end
end
