defmodule Kvdb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Kvdb.Worker.start_link(arg)
      # {Kvdb.Worker, arg}
      Kvdb.Worker
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    :ets.new(Kvdb.Store, [:named_table, :public])
    opts = [strategy: :one_for_one, name: Kvdb.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
