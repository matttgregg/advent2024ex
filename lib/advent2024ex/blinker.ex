defmodule Advent2024ex.Blinker do
  use GenServer

  @impl true
  def init(_) do
    {:ok, %{lengths: %{}, blinks: %{}}}
  end

  def start() do
    GenServer.start(__MODULE__, nil)
  end

  def blink_length(_pid, _s, 0) do
    # No blinking to do!
    1
  end

  def blink_length(pid, s, n) do
    if v = GenServer.call(pid, {:length, s, n}) do
      v
    else
      result = do_blink(s) |> Enum.map(&blink_length(pid, &1, n - 1)) |> Enum.sum()
      cache_blink_length(pid, s, n, result)
      result
    end
  end

  def cache_blink_length(pid, s, n, v) do
    GenServer.call(pid, {:put_length, s, n, v})
  end

  @impl true
  def handle_call({:length, s, n}, _from, %{lengths: lengths} = state) do
    if v = Map.get(lengths, {s, n}) do
      {:reply, v, state}
    else
      {:reply, nil, state}
    end
  end

  def handle_call({:put_length, s, n, v}, _from, state) do
    {:reply, :ok, Map.update(state, :lengths, %{{s, n} => v}, &Map.put(&1, {s, n}, v))}
  end

  def do_blink(s) do
    cond do
      s == 0 ->
        [1]

      rem(String.length("#{s}"), 2) == 0 ->
        srep = "#{s}"
        chunk_size = div(String.length(srep), 2)

        [
          String.to_integer(String.slice(srep, 0, chunk_size)),
          String.to_integer(String.slice(srep, chunk_size, chunk_size))
        ]

      true ->
        [2024 * s]
    end
  end
end
