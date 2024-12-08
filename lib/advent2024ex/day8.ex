defmodule Advent2024ex.Day8 do
  def load_grid(fname) do
    grid = File.read!(fname) |> String.trim() |> String.to_charlist()
    # Work out the bounds
    # Because we trimmed, last line doesn't have a \n
    rows = Enum.count(grid, fn x -> x == ?\n end) + 1
    cols = div(Enum.count(grid) + 1, rows) - 1

    {grid |> Enum.reject(fn x -> x == ?\n end) |> to_string(), rows, cols}
  end

  def at11!({grid, _rows, cols}, {r, c}) do
    String.at(grid, (r - 1) * cols + c - 1)
  end

  def in?({_, rows, cols}, {r, c}) do
    r > 0 && r <= rows && c > 0 && c <= cols
  end

  def antenna?(g, coord) do
    if (at = at11!(g, coord)) != "." do
      [{at, coord}]
    else
      []
    end
  end

  @doc """
  Like map.new but collect multiple values
  """
  def maplist_build(kvs) do
    Enum.reduce(kvs, %{}, fn {k, v}, acc ->
      if Map.has_key?(acc, k) do
        Map.update!(acc, k, fn old -> [v | old] end)
      else
        Map.put(acc, k, [v])
      end
    end)
  end

  def all_antenna({_grid, rows, cols} = g) do
    for r <- 1..rows, c <- 1..cols do
      {r, c}
    end
    |> Enum.flat_map(&antenna?(g, &1))
    |> maplist_build
  end

  def node_for_pair({r1, c1}, {r2, c2}) do
    if r1 == r2 && c1 == c2 do
      # An antenna doesn't generate a node with itself
      []
    else
      [{2 * r2 - r1, 2 * c2 - c1}, {2 * r1 - r2, 2 * c1 - c2}]
    end
  end

  def nodes_with_resonance_a_to_b({_, rows, cols}, {r1, c1}, {r2, c2}) do
    # Generally we have beams b + n(a->b), n = 1...
    #  b + n(b - a) = b(n + 1) - na for n = 1... (The simple case was just n = 1)

    # Some fiddle maths to work out our max n
    rdelta = r2 - r1
    cdelta = c2 - c1

    rn =
      cond do
        rdelta > 0 -> Integer.floor_div(rows - r2, rdelta)
        rdelta < 0 -> Integer.floor_div(r2, -rdelta)
        true -> 0
      end

    cn =
      cond do
        cdelta > 0 -> Integer.floor_div(cols - c2, cdelta)
        cdelta < 0 -> Integer.floor_div(c2, -cdelta)
        true -> 0
      end

    n = min(rn, cn) + 1

    if n <= 0 do
      # An antenna doesn't generate a node with itself
      []
    else
      for i <- 1..n, do: {(i + 1) * r2 - i * r1, (i + 1) * c2 - i * c1}
    end
  end

  def nodes_with_resonance(g, a, b) do
    Enum.concat(nodes_with_resonance_a_to_b(g, a, b), nodes_with_resonance_a_to_b(g, b, a))
  end

  def nodes_for_freq(as, pair_func) do
    for a <- as, b <- as do
      {a, b}
    end
    |> Enum.flat_map(fn {a, b} -> pair_func.(a, b) end)
  end

  def all_antinodes(g, pair_func) do
    all_as = all_antenna(g)

    for vals <- Map.values(all_as) do
      nodes_for_freq(vals, pair_func)
    end
    |> Enum.concat()
    |> Enum.filter(&in?(g, &1))
    |> Enum.uniq()
    |> Enum.count()
  end

  def run(test \\ false) do
    fname = if test, do: "./puzzle_data/day8.tst", else: "./puzzle_data/day8"
    g = load_grid(fname)
    part1 = all_antinodes(g, &node_for_pair/2)
    part2 = all_antinodes(g, &nodes_with_resonance(g, &1, &2))

    [part1, part2]
  end
end
