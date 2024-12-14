defmodule Advent2024ex.Day14 do
  def robot(text) do
    case Regex.run(~r{p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)}, text) do
      [_, x, y, vx, vy] ->
        [
          {{String.to_integer(x), String.to_integer(y)},
           {String.to_integer(vx), String.to_integer(vy)}}
        ]

      _ ->
        []
    end
  end

  def robots(txt) do
    String.split(txt, "\n") |> Enum.flat_map(&robot/1)
  end

  def correct_coord({x, y}, {rows, cols}) do
    cx = if x >= 0, do: x, else: x + cols
    cy = if y >= 0, do: y, else: y + rows
    {cx, cy}
  end

  def robot_after({x, y}, {vx, vy}, {rows, cols}, steps) do
    {
      rem(x + steps * vx, cols),
      rem(y + steps * vy, rows)
    }
    |> correct_coord({rows, cols})
  end

  def quadrants({x, y}, {rows, cols}) do
    mid_x = div(cols - 1, 2)
    mid_y = div(rows - 1, 2)

    cond do
      x < mid_x and y < mid_y -> {1, 0, 0, 0}
      x > mid_x and y < mid_y -> {0, 1, 0, 0}
      x < mid_x and y > mid_y -> {0, 0, 1, 0}
      x > mid_x and y > mid_y -> {0, 0, 0, 1}
      true -> {0, 0, 0, 0}
    end
  end

  def plus_quads({a1, b1, c1, d1}, {a2, b2, c2, d2}), do: {a1 + a2, b1 + b2, c1 + c2, d1 + d2}
  def cost_quads({a, b, c, d}), do: a * b * c * d

  def run_robots(robots, size, steps) do
    Enum.map(robots, fn {pos, vel} -> robot_after(pos, vel, size, steps) end)
    |> Enum.map(&quadrants(&1, size))
    |> Enum.reduce(&plus_quads/2)
    |> cost_quads()
  end

  defp plot_row(robots, row, {_rows, cols}) do
    for i <- 1..cols do
      if MapSet.member?(robots, {i - 1, row}), do: "*", else: "."
    end
    |> Enum.join("")
  end

  def plot_after(robots, {rows, _cols} = size, steps) do
    robots =
      Enum.map(robots, fn {pos, vel} -> robot_after(pos, vel, size, steps) end)
      |> MapSet.new()

    for i <- 1..rows do
      plot_row(robots, i - 1, size)
    end
    |> Enum.join("\n")
  end

  @day 14
  def run(test \\ false, output \\ true) do
    robots = Advent2024ex.file_for(@day, test) |> File.read!() |> robots()
    size = if test, do: {7, 11}, else: {103, 101}
    part1 = run_robots(robots, size, 100)

    tree_at = 7847

    if output do
      iter(tree_at, test) |> IO.puts()
    end

    [part1, tree_at]
  end

  def iter(steps, test \\ false) do
    robots = Advent2024ex.file_for(@day, test) |> File.read!() |> robots()
    size = if test, do: {7, 11}, else: {103, 101}
    IO.puts("After: #{steps}")
    plot_after(robots, size, steps) |> IO.puts()
    IO.puts("-----#{steps}------")
  end

  def iter_many(steps, pause, test \\ false) do
    robots = Advent2024ex.file_for(@day, test) |> File.read!() |> robots()
    size = if test, do: {7, 11}, else: {103, 101}

    for s <- 0..steps do
      step = 979 + s * 101
      IO.puts("After: #{step}")
      plot_after(robots, size, step) |> IO.puts()
      IO.puts("-----#{step}------")
      :timer.sleep(pause)
    end

    nil
  end
end
