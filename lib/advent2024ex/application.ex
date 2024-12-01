defmodule Advent2024ex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Advent2024exWeb.Telemetry,
      Advent2024ex.Repo,
      {DNSCluster, query: Application.get_env(:advent2024ex, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Advent2024ex.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Advent2024ex.Finch},
      # Start a worker by calling: Advent2024ex.Worker.start_link(arg)
      # {Advent2024ex.Worker, arg},
      # Start to serve requests, typically the last entry
      Advent2024exWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Advent2024ex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Advent2024exWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
