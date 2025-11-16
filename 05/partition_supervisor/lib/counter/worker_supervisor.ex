defmodule Counter.WorkerSupervisor do
  use DynamicSupervisor

  def start_link(_) do
    # * __MODULE__ only tells you which module implements the DynamicSupervisor
    # * interface
    DynamicSupervisor.start_link(__MODULE__, nil)
  end

  def start_worker(name) do
    DynamicSupervisor.start_child(
      # * Adding the own supervisor to the table of dynamic supervisors using via
      {:via, PartitionSupervisor, {Counter.WorkerSupervisors, self()}},
      {Counter.Worker, name})
  end

  @impl true
  def init(_) do
    IO.puts("Counter.WorkerSupervisor starting ... #{inspect(self())}")
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
