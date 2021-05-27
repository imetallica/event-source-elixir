defmodule Es.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Es.Worker.start_link(arg)
      # {Es.Worker, arg}
      {Plug.Cowboy, scheme: :http, plug: Es.Integration.Router},
      {Registry, keys: :unique, name: LocalRegistry, partitions: System.schedulers_online()},
      Es.Wiring,
      Es.Projections.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Es.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
