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

  def find_path(hm, {grow, gcol}, {srow, scol} = gdir, path, plength, {rows, cols} = bounds) do
    {nrow, ncol} = {grow + srow, gcol + scol}

    # Is this outside the map? Finish and return the step count.
    if nrow < 0 || nrow >= rows || ncol < 0 || ncol >= cols do
      {:left, plength}
    else
      nchar = Map.get(hm, {nrow, ncol})

      cond do
        nchar == ?# ->
          if Map.has_key?(path, {grow, gcol, gdir}) do
            # We've looped
            {:loop}
          else
            # This is an obstacle? Turn and try again.
            npath = Map.put(path, {grow, gcol, gdir}, true)
            find_path(hm, {grow, gcol}, guard_turn(gdir), npath, plength, bounds)
          end

        true ->
          # This an univisited square? Increment, update the map, move and keep going.
          find_path(hm, {nrow, ncol}, gdir, path, plength + 1, bounds)
      end
    end
  end

  def find_path_with_obstacles(
        hm,
        {grow, gcol},
        {srow, scol} = gdir,
        path,
        loop_count,
        obstacles,
        {rows, cols} = bounds
      ) do
    {nrow, ncol} = {grow + srow, gcol + scol}

    # Is this outside the map? Finish and return the loop count.
    if nrow < 0 || nrow >= rows || ncol < 0 || ncol >= cols do
      loop_count
    else
      nchar = Map.get(hm, {nrow, ncol})

      cond do
        nchar == ?# ->
          if Map.has_key?(path, {grow, gcol, gdir}) do
            # We've looped
            {:loop}
          else
            # This is an obstacle? Turn and try again.
            npath = Map.put(path, {grow, gcol, gdir}, true)

            find_path_with_obstacles(
              hm,
              {grow, gcol},
              guard_turn(gdir),
              npath,
              loop_count,
              obstacles,
              bounds
            )
          end

        Map.has_key?(obstacles, {nrow, ncol}) ->
          # We've already tried an obstacle here - just keep going on the main path.
          find_path_with_obstacles(
            hm,
            {nrow, ncol},
            gdir,
            path,
            loop_count,
            obstacles,
            bounds
          )

        true ->
          # This an unvisited square? Try pretending it's an obstacle and see what happens?

          makes_loop =
            case find_path(Map.put(hm, {nrow, ncol}, ?#), {grow, gcol}, gdir, path, 0, bounds) do
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
            path,
            loop_count + makes_loop,
            Map.put(obstacles, {nrow, ncol}, true),
            bounds
          )
      end
    end
  end

  def get_bounds(m) do
    rows = Enum.count(m)
    cols = Enum.map(m, &Enum.count/1) |> Enum.max()
    {rows, cols}
  end

  def count_steps(fname) do
    m = map_from_file(fname)
    {grow, gcol} = find_guard(m)
    gdir = Enum.at(m, grow) |> Enum.at(gcol) |> dir_from_char()
    hm = hashmap_from_map(m)
    bounds = get_bounds(m)
    {:left, plength} = find_path(hm, {grow, gcol}, gdir, %{}, 0, bounds)
    plength
  end

  def make_loops(fname) do
    m = map_from_file(fname)
    {grow, gcol} = find_guard(m)
    gdir = Enum.at(m, grow) |> Enum.at(gcol) |> dir_from_char()
    hm = hashmap_from_map(m)
    bounds = get_bounds(m)
    find_path_with_obstacles(hm, {grow, gcol}, gdir, %{}, 0, %{}, bounds)
  end

  def run(test \\ false) do
    fname = if test, do: "./puzzle_data/day6.tst", else: "./puzzle_data/day6"
    part1 = count_steps(fname)
    part2 = make_loops(fname)

    [part1, part2]
  end
end
