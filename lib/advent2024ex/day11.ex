defmodule Advent2024ex.Day11 do
  alias Advent2024ex.Blinker

  @day 11

  def blink(s) do
    Blinker.do_blink(s)
  end

  def blink_length(s, n) when is_binary(s) do
    String.split(s) |> Enum.map(&String.to_integer/1) |> blink_length(n)
  end

  def blink_length(s, n) when is_list(s) do
    {:ok, blinker} = Blinker.start()
    Enum.map(s, &Blinker.blink_length(blinker, &1, n)) |> Enum.sum()
  end

  def blink_length(s, n) when is_integer(s) do
    {:ok, blinker} = Blinker.start()
    Blinker.blink_length(blinker, s, n)
  end

  def run(test \\ false) do
    data = Advent2024ex.file_for(@day, test) |> File.read!()
    part1 = blink_length(data, 25)
    part2 = blink_length(data, 75)
    [part1, part2]
  end
end
