defmodule Advent2024ex.Day13 do
  @day 13

  def solve(ax, ay, bx, by, px, py, 0) do
    # We look for solutions to pressing a m times, b n times =>
    # m, n s.t. px = m.ax + n.bx, py = m.ay + n.by
    # We can eliminate m:
    # n = (ay.px - ax.py) / (bx.ay - ax.by)
    #
    # And then solve for m:
    # m = (px - n.bx) / ax

    cond do
      # Insoluble
      bx * ay - ax * by == 0 || ax == 0 ->
        nil

      true ->
        n_rem = rem(ay * px - ax * py, bx * ay - ax * by)
        n = div(ay * px - ax * py, bx * ay - ax * by)

        m_rem = rem(px - n * bx, ax)
        m = div(px - n * bx, ax)

        if n_rem == 0 && m_rem == 0 do
          {m, n}
        else
          nil
        end
    end
  end

  def solve(ax, ay, bx, by, px, py, adj) do
    # Add the adjustment to the prize coords before solving.
    solve(ax, ay, bx, by, px + adj, py + adj, 0)
  end

  def cost({m, n}), do: 3 * m + n
  def cost(nil), do: 0

  def parse_a(text) do
    case Regex.run(~r{Button A: X\+(\d+), Y\+(\d+)}, text) do
      [_, x, y] -> {String.to_integer(x), String.to_integer(y)}
      _ -> nil
    end
  end

  def parse_b(text) do
    case Regex.run(~r{Button B: X\+(\d+), Y\+(\d+)}, text) do
      [_, x, y] -> {String.to_integer(x), String.to_integer(y)}
      _ -> nil
    end
  end

  def parse_prize(text) do
    case Regex.run(~r{Prize: X\=(\d+), Y\=(\d+)}, text) do
      [_, x, y] -> {String.to_integer(x), String.to_integer(y)}
      _ -> nil
    end
  end

  def cost_machines(text, adj) do
    String.trim(text)
    |> String.split("\n")
    |> Enum.filter(&(String.length(String.trim(&1)) > 0))
    |> Enum.chunk_every(3)
    |> Enum.map(fn [a, b, prize] -> {parse_a(a), parse_b(b), parse_prize(prize)} end)
    |> Enum.map(fn {{ax, ay}, {bx, by}, {px, py}} -> solve(ax, ay, bx, by, px, py, adj) end)
    |> Enum.map(&cost/1)
    |> Enum.sum()
  end

  def run(test \\ false) do
    data = Advent2024ex.file_for(@day, test) |> File.read!()
    part1 = cost_machines(data, 0)
    part2 = cost_machines(data, 10_000_000_000_000)
    [part1, part2]
  end
end
