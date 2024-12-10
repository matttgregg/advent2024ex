defmodule Advent2024ex.Day9 do
  defstruct running: 0, forward: [], back: [], i: 0, blocks_left: 0

  def load_data(fname) do
    File.read!(fname) |> parse_data()
  end

  def parse_data(data) do
    disk_map =
      data |> String.trim() |> String.codepoints() |> Enum.map(&String.to_integer/1)

    forward =
      for i <- 1..Enum.count(disk_map) do
        if rem(i, 2) == 0 do
          # Even indices are spaces
          {:space, Enum.at(disk_map, i - 1)}
        else
          # Odd indices are data
          {div(i - 1, 2), Enum.at(disk_map, i - 1)}
        end
      end

    data_only = Enum.filter(forward, fn {x, _} -> is_integer(x) end)
    blocks = Enum.map(data_only, fn {_id, n} -> n end) |> Enum.sum()

    back = Enum.reverse(data_only)

    # The number of data blocks is the sum of alternate values.
    %__MODULE__{
      running: 0,
      forward: forward,
      back: back,
      i: 0,
      blocks_left: blocks
    }
  end

  def step_block(%__MODULE__{blocks_left: 0, running: running}) do
    # We've read all the blocks that we need to. Return the answer.
    running
  end

  def step_block(%__MODULE__{forward: [{_, 0} | rest]} = acc) do
    # We've exhausted a block - move to the next one.
    step_block(%__MODULE__{acc | forward: rest})
  end

  def step_block(%__MODULE__{forward: [{:space, _} | _], back: [{_, 0} | rest]} = acc) do
    # We're reading data from the back, but have run out of data. We move onto the
    # next data block from the back.
    step_block(%__MODULE__{acc | back: rest})
  end

  def step_block(
        %__MODULE__{
          forward: [{:space, fwdn} | frest],
          back: [{bid, backn} | backrest],
          i: i,
          blocks_left: blocks,
          running: running
        } = acc
      ) do
    # We're reading data from the back, and have some available

    step_block(%__MODULE__{
      acc
      | forward: [{:space, fwdn - 1} | frest],
        back: [{bid, backn - 1} | backrest],
        i: i + 1,
        blocks_left: blocks - 1,
        running: running + i * bid
    })
  end

  def step_block(%__MODULE__{forward: [{fid, 0} | rest]} = acc)
      when is_integer(fid) do
    # We're reading a data block, but have run out of data
    # This means we move to the next block.
    step_block(%__MODULE__{acc | forward: rest})
  end

  def step_block(
        %__MODULE__{
          forward: [{fid, n} | rest],
          i: i,
          blocks_left: blocks,
          running: running
        } = acc
      )
      when is_integer(fid) do
    # We're reading data, and have some available. Consume and move on.
    step_block(%__MODULE__{
      acc
      | forward: [{fid, n - 1} | rest],
        i: i + 1,
        blocks_left: blocks - 1,
        running: running + i * fid
    })
  end

  defp fits({:space, n}, {_id, size}) do
    size <= n
  end

  defp fits(_, _), do: false

  def compress_map(dm, []) do
    dm
  end

  def compress_map(dm, [{_, size} = el | rst]) do
    move_from = Enum.find_index(dm, fn x -> x == el end)

    # See if there's a space that can take it
    if (move_to = Enum.find_index(dm, &fits(&1, el))) && move_to < move_from do
      # We don't care about closing gaps - nothing after will get moved.
      dm_with_space = List.replace_at(dm, move_from, {:space, size})

      {:space, gap_size} = Enum.at(dm, move_to)

      # The existing space is shrunk
      new_dm =
        dm_with_space
        |> List.replace_at(move_to, {:space, gap_size - size})
        |> List.insert_at(move_to, el)

      compress_map(new_dm, rst)
    else
      # We can't move this element - just leave it on the end and keep going.
      compress_map(dm, rst)
    end
  end

  defp string_for_el({:space, n}), do: String.duplicate(".", n)
  defp string_for_el({id, n}), do: String.duplicate("#{id}", n)

  def debug_dmap(dm) do
    Enum.map(dm, &string_for_el/1) |> Enum.join()
  end

  def load_and_compress_from_file(fname) do
    File.read!(fname) |> load_and_compress()
  end

  def load_and_compress(data) do
    %__MODULE__{forward: forward, back: back} = parse_data(data)
    compress_map(forward, back)
  end

  def evaluate_dm([], _, acc), do: acc

  def evaluate_dm([{idx, size} | rest], i, acc) when is_integer(idx) do
    increment = idx * div(size * (2 * i + size - 1), 2)
    evaluate_dm(rest, i + size, acc + increment)
  end

  def evaluate_dm([{:space, n} | rest], i, acc) do
    evaluate_dm(rest, i + n, acc)
  end

  def run(test \\ false) do
    fname = if test, do: "./puzzle_data/day9.tst", else: "./puzzle_data/day9"
    part1 = load_data(fname) |> step_block()
    part2 = load_and_compress_from_file(fname) |> evaluate_dm(0, 0)

    [part1, part2]
  end
end
