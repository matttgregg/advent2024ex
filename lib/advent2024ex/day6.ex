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

  defp guard_turn(dir) do
    case dir do
      {-1, 0} -> {0, 1}
      {0, 1} -> {1, 0}
      {1, 0} -> {0, -1}
      {0, -1} -> {-1, 0}
    end
  end

  def find_guard(m) do
    row = Enum.find_index(m, fn row -> Enum.any?(row, &guard_char/1) end)
    col = Enum.at(m, row) |> Enum.find_index(&guard_char/1)
    {row, col}
  end

  def find_path(hm, {grow, gcol}, {srow, scol} = gdir, path) do
    {nrow, ncol} = {grow + srow, gcol + scol}
    npath = Map.put(path, {grow, gcol, gdir}, true)

    # Is this outside the map? Finish and return the step count.
    if !Map.has_key?(hm, {nrow, ncol}) do
      {:left, npath}
    else
      nchar = Map.get(hm, {nrow, ncol})

      cond do
        Map.has_key?(path, {grow, gcol, gdir}) ->
          # We've looped
          {:loop}

        nchar == ?# ->
          # This is an obstacle? Turn and try again.
          find_path(hm, {grow, gcol}, guard_turn(gdir), npath)

        true ->
          # This an univisited square? Increment, update the map, move and keep going.
          find_path(hm, {nrow, ncol}, gdir, npath)
      end
    end
  end

  def find_path_with_obstacles(hm, {grow, gcol}, {srow, scol} = gdir, path, loop_count, obstacles) do
    {nrow, ncol} = {grow + srow, gcol + scol}
    npath = Map.put(path, {grow, gcol, gdir}, true)

    # Is this outside the map? Finish and return the loop count.
    if !Map.has_key?(hm, {nrow, ncol}) do
      loop_count
    else
      nchar = Map.get(hm, {nrow, ncol})

      cond do
        Map.has_key?(path, {grow, gcol, gdir}) ->
          # We've looped
          loop_count

        nchar == ?# ->
          # This is an obstacle? Turn and try again.
          find_path_with_obstacles(
            hm,
            {grow, gcol},
            guard_turn(gdir),
            npath,
            loop_count,
            obstacles
          )

        Map.has_key?(obstacles, {nrow, ncol}) ->
          # We've already tried an obstacle here - just keep going on the main path.
          find_path_with_obstacles(
            hm,
            {nrow, ncol},
            gdir,
            npath,
            loop_count,
            obstacles
          )

        true ->
          # This an unvisited square? Try pretending it's an obstacle and see what happens?

          makes_loop =
            case find_path(Map.put(hm, {nrow, ncol}, ?#), {grow, gcol}, gdir, path) do
              {:loop} ->
                1

              _ ->
                0
            end

          # Now we've checked, keep going with the main path.
          find_path_with_obstacles(
            hm,
            {nrow, ncol},
            gdir,
            npath,
            loop_count + makes_loop,
            Map.put(obstacles, {nrow, ncol}, true)
          )
      end
    end
  end

  def count_steps(fname) do
    m = map_from_file(fname)
    {grow, gcol} = find_guard(m)
    gdir = Enum.at(m, grow) |> Enum.at(gcol) |> dir_from_char()
    hm = hashmap_from_map(m)
    {:left, path} = find_path(hm, {grow, gcol}, gdir, %{})
    Map.keys(path) |> Enum.map(fn {r, c, _c} -> {r, c} end) |> Enum.uniq() |> Enum.count()
  end

  def make_loops(fname) do
    m = map_from_file(fname)
    {grow, gcol} = find_guard(m)
    gdir = Enum.at(m, grow) |> Enum.at(gcol) |> dir_from_char()
    hm = hashmap_from_map(m)
    find_path_with_obstacles(hm, {grow, gcol}, gdir, %{}, 0, %{})
  end

  def run(test \\ false) do
    fname = if test, do: "./puzzle_data/day6.tst", else: "./puzzle_data/day6"
    part1 = count_steps(fname)
    part2 = make_loops(fname)

    [part1, part2]
  end
end
