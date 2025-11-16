# Global counter worker
defmodule Counter.Worker do
  use GenServer
  @name {:global, __MODULE__} # Making it a global module

  def start_link(n \\ 0) do
    # Start and link to the parent automatically
    # Uses spawn_link
    GenServer.start_link(__MODULE__, n, name: @name)
  end

  def inc(amt \\ 1) do
    GenServer.cast(@name, {:inc, amt})
  end

  def value() do
    GenServer.call(@name, :value)
  end

  @impl true
  def init(n) do
    {:ok, Counter.Store.get() || n}
  end

  @impl true
  def handle_call(:value, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:inc, amt}, state) do
    {:noreply, state + amt}
  end

  # When server dies, does this. Not the safest
  @impl true
  def terminate(_reason, state) do
    Counter.Store.put(state)
  end
end
