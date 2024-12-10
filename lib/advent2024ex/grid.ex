defmodule Advent2024ex.Grid do
  def load_grid(fname) do
    grid = File.read!(fname) |> String.trim() |> String.to_charlist()
    # Work out the bounds
    # Because we trimmed, last line doesn't have a \n
    rows = Enum.count(grid, fn x -> x == ?\n end) + 1
    cols = div(Enum.count(grid) + 1, rows) - 1

    {grid |> Enum.reject(fn x -> x == ?\n end) |> to_string(), rows, cols}
  end

  def at11!({grid, _rows, cols}, {r, c}) do
    :binary.at(grid, (r - 1) * cols + c - 1)
  end

  def at11({_grid, rows, cols} = g, {r, c} = p) do
    if r <= 0 || c <= 0 || r > rows || c > cols do
      nil
    else
      at11!(g, p)
    end
  end

  def digit_at11(g, p) do
    if is_number(v = at11(g, p)) do
      v - ?0
    else
      nil
    end
  end

  def in?({_, rows, cols}, {r, c}) do
    r > 0 && r <= rows && c > 0 && c <= cols
  end

  def linear_neighbours({r, c}) do
    [{r - 1, c}, {r + 1, c}, {r, c - 1}, {r, c + 1}]
  end

  def each_coord({_, rows, cols} = g, f) do
    for r <- 1..rows, c <- 1..cols do
      f.(g, {r, c})
    end
  end
end
