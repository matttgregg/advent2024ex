defmodule Advent2024ex.Day9 do
  defstruct running: 0, forward: [], back: [], mode: :data, i: 0, blocks_left: 0, fid: 0

  def load_data(fname) do
    disk_map =
      File.read!(fname) |> String.trim() |> String.codepoints() |> Enum.map(&String.to_integer/1)

    data_only = Enum.drop_every([0 | disk_map], 2)
    blocks = Enum.sum(data_only)

    back =
      for i <- 1..Enum.count(data_only) do
        i - 1
      end
      |> Enum.zip(data_only)
      |> Enum.reverse()

    # The number of data blocks is the sum of alternate values.
    %__MODULE__{
      running: 0,
      forward: disk_map,
      back: back,
      i: 0,
      blocks_left: blocks,
      mode: :data,
      fid: 0
    }
  end

  def step_block(%__MODULE__{blocks_left: 0, running: running}, _) do
    # We've read all the blocks that we need to. Return the answer.
    running
  end

  def step_block(%__MODULE__{mode: :data, forward: [0 | rest], fid: fid} = acc, contig) do
    # We're reading a data block, but have run out of data
    # This means we drop, and shift to space mode.
    step_block(%__MODULE__{acc | mode: :space, forward: rest, fid: fid + 1}, contig)
  end

  def step_block(%__MODULE__{mode: :space, forward: [0 | rest]} = acc, contig) do
    # We're reading a space block, but have run out of space
    # Flip back to data mode.
    step_block(%__MODULE__{acc | mode: :data, forward: rest}, contig)
  end

  def step_block(
        %__MODULE__{
          mode: :data,
          forward: [n | rest],
          i: i,
          blocks_left: blocks,
          running: running,
          fid: fid
        } = acc,
        contig
      ) do
    # We're reading data, and have some available. Consume and move on.
    step_block(
      %__MODULE__{
        acc
        | forward: [n - 1 | rest],
          i: i + 1,
          blocks_left: blocks - 1,
          running: running + i * fid
      },
      contig
    )
  end

  def step_block(%__MODULE__{mode: :space, back: [{_, 0} | rest]} = acc, contig) do
    # We're reading data from the back, but have run out of data. We move onto the
    # next data block from the back.
    step_block(%__MODULE__{acc | mode: :space, back: rest}, contig)
  end

  def step_block(
        %__MODULE__{
          mode: :space,
          forward: [fwdn | frest],
          back: [{bid, backn} | backrest],
          i: i,
          blocks_left: blocks,
          running: running
        } = acc,
        false
      ) do
    # We're reading data from the back, and have some available

    step_block(
      %__MODULE__{
        acc
        | forward: [fwdn - 1 | frest],
          back: [{bid, backn - 1} | backrest],
          i: i + 1,
          blocks_left: blocks - 1,
          running: running + i * bid
      },
      false
    )
  end

  def step_block(
        %__MODULE__{
          mode: :space,
          forward: [fwdn | frest],
          back: back,
          i: i,
          blocks_left: blocks,
          running: running
        } = acc,
        true
      ) do
    # We're reading data from the back, have some, but only allow full blocks.

    # Find which block we can use.
    block_index = Enum.find_index(back, fn {_, size} -> size <= fwdn end)

    if block_index do
      {bid, size} = Enum.at(back, block_index)
      IO.puts("Fitting #{bid} length #{size} at #{i}")
      increment = bid * div((i + (i + size - 1)) * size, 2)

      step_block(
        %__MODULE__{
          acc
          | forward: [fwdn - size | frest],
            back: List.delete_at(back, block_index),
            i: i + size,
            blocks_left: blocks - size,
            running: running + increment
        },
        true
      )
    else
      # There is no block that will fit. Just skip the rest of this space and read data again.
      step_block(
        %__MODULE__{
          acc
          | forward: frest,
            i: i + fwdn,
            mode: :data
        },
        true
      )
    end
  end

  def run(test \\ false) do
    fname = if test, do: "./puzzle_data/day9.tst", else: "./puzzle_data/day9"
    disk_map = load_data(fname)
    part1 = step_block(disk_map, false)
    part2 = step_block(disk_map, true)

    [part1, part2]
  end
end
