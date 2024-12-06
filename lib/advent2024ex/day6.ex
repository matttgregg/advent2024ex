defmodule Advent2024ex.Day6 do
  def dir_from_char(c) do
    case c do
      ?^ -> {-1, 0}
      ?> -> {0, 1}
      ?< -> {0, -1}
      ?v -> {1, 0}
    end
  end

  def map_from_file(fname) do
    File.read!(fname) |> String.split("\n") |> Enum.map(&String.to_charlist/1)
  end

  def hashmap_from_map(m) do
    for r <- 1..Enum.count(m) do
      for c <- 1..Enum.count(Enum.at(m, r - 1)) do
        {{r - 1, c - 1}, Enum.at(m, r - 1) |> Enum.at(c - 1)}
      end
    end
    |> Enum.flat_map(fn x -> x end)
    |> Map.new()
  end

  defp guard_char(c) do
    case c do
      ?^ -> true
      ?> -> true
      ?< -> true
      ?v -> true
      _ -> false
    end
  end

  defp guard_turn(c) do
    case c do
      ?^ -> ?>
      ?> -> ?v
      ?< -> ?^
      ?v -> ?<
    end
  end

  def find_guard(m) do
    row = Enum.find_index(m, fn row -> Enum.any?(row, &guard_char/1) end)
    col = Enum.at(m, row) |> Enum.find_index(&guard_char/1)
    {row, col}
  end

  def find_path(hm, {grow, gcol}, gchar, path) do
    {srow, scol} = dir_from_char(gchar)
    {nrow, ncol} = {grow + srow, gcol + scol}
    npath = Map.put(path, {grow, gcol, gchar}, true)

    # Is this outside the map? Finish and return the step count.
    if !Map.has_key?(hm, {nrow, ncol}) do
      {:left, Map.keys(npath) |> Enum.map(fn {r, c, _c} -> {r, c} end) |> Enum.uniq()}
    else
      nchar = Map.get(hm, {nrow, ncol})

      cond do
        Map.has_key?(path, {grow, gcol, gchar}) ->
          # We've looped
          {:loop}

        nchar == ?# ->
          # This is an obstacle? Turn and try again.
          find_path(hm, {grow, gcol}, guard_turn(gchar), npath)

        true ->
          # This an univisited square? Increment, update the map, move and keep going.
          find_path(hm, {nrow, ncol}, gchar, npath)
      end
    end
  end

  def count_steps(fname) do
    m = map_from_file(fname)
    {grow, gcol} = find_guard(m)
    gchar = Enum.at(m, grow) |> Enum.at(gcol)
    hm = hashmap_from_map(m)
    {:left, steps} = find_path(hm, {grow, gcol}, gchar, %{})
    Enum.count(steps)
  end

  def make_loops(fname) do
    m = map_from_file(fname)
    {grow, gcol} = find_guard(m)
    gchar = Enum.at(m, grow) |> Enum.at(gcol)
    hm = hashmap_from_map(m)
    {:left, steps} = find_path(hm, {grow, gcol}, gchar, %{})

    # Now, try inserting obstacles at each path point in turn to see if that causes a loop
    Enum.count(steps, &makes_loop?(hm, {grow, gcol}, gchar, &1))
  end

  defp makes_loop?(hm, {grow, gcol}, gchar, {orow, ocol}) do
    if orow == grow && ocol == gcol do
      # We can't put an obstacle where the guard is.
      false
    else
      case find_path(Map.put(hm, {orow, ocol}, ?#), {grow, gcol}, gchar, %{}) do
        {:left, _} ->
          false

        {:loop} ->
          true
      end
    end
  end

  def run(test \\ false) do
    fname = if test, do: "./puzzle_data/day6.tst", else: "./puzzle_data/day6"
    part1 = count_steps(fname)
    part2 = make_loops(fname)

    [part1, part2]
  end
end
