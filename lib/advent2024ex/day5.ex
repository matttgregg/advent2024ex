defmodule Advent2024ex.Day5 do
  def load_orders_pages(fname) do
    [orders, pages] = File.read!(fname) |> String.split("\n\n")

    parsed_orders =
      String.split(orders, "\n")
      |> Enum.map(&String.split(&1, "|"))
      |> Enum.map(fn [beforep, afterp] ->
        {String.to_integer(beforep), String.to_integer(afterp)}
      end)
      |> Enum.reduce(%{}, fn {beforep, afterp}, omap ->
        Map.update(omap, afterp, %{beforep => true}, &Map.put(&1, beforep, true))
      end)

    parsed_pages =
      String.split(pages, "\n")
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(fn group -> Enum.map(group, &String.to_integer/1) end)

    {parsed_orders, parsed_pages}
  end

  def verify_value(%{forbid: forbidden, fail: fail} = acc, order_map, val) do
    cond do
      # If we've already failed, just return.
      fail ->
        acc

      # If we're violating a constraint, fail.
      Enum.find(forbidden, false, &(&1 == val)) ->
        %{acc | fail: true}

      # Otherwise, just update the forbidden list if necessary.
      true ->
        %{forbid: Enum.concat(forbidden, Map.get(order_map, val, %{}) |> Map.keys()), fail: false}
    end
  end

  def violates_order(order_map, pages) do
    %{fail: failed} =
      Enum.reduce(pages, %{forbid: [], fail: false}, fn val, acc ->
        verify_value(acc, order_map, val)
      end)

    failed
  end

  def middle_if_valid(orders, group) do
    if violates_order(orders, group) do
      0
    else
      Enum.at(group, round((Enum.count(group) - 1) / 2))
    end
  end

  def check_all_pages({orders, pages}) do
    Enum.map(pages, &middle_if_valid(orders, &1)) |> Enum.sum()
  end

  def failed_pages(orders, pages) do
    Enum.filter(pages, &violates_order(orders, &1))
  end

  def fix_page(orders, group) do
    sorter = fn a, b ->
      # Return true if first argument precedes, or equal.
      # We therefore check for the *wrong* order
      !(Map.get(orders, a, %{}) |> Map.has_key?(b))
    end

    Enum.sort(group, sorter)
  end

  def fixed_pages(orders, pages) do
    failed_pages(orders, pages) |> Enum.map(&fix_page(orders, &1))
  end

  def fixed_pages_middle({orders, pages}) do
    fixed_pages(orders, pages)
    |> Enum.map(fn x -> Enum.at(x, round((Enum.count(x) - 1) / 2)) end)
    |> Enum.sum()
  end

  def run(test \\ false) do
    fname = if test, do: "./puzzle_data/day5.tst", else: "./puzzle_data/day5"
    part1 = load_orders_pages(fname) |> check_all_pages()
    part2 = load_orders_pages(fname) |> fixed_pages_middle()
    [part1, part2]
  end
end
