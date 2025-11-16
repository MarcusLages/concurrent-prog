defmodule Counter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Counter.Worker.start_link(arg)
      # {Counter.Worker, arg}

      # * Start the process directory register used to map worker names to PIDs
      # * Counter.Registry is just its name
      # * Giving unique keys avoids many workers with the same name (PID groups)
      {Registry, name: Counter.Registry, keys: :unique},
      DynamicSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    :ets.new(Counter.Store, [:named_table, :public])
    opts = [strategy: :one_for_one, name: Counter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
