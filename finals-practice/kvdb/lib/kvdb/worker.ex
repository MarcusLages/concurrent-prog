defmodule Kvdb.Worker do
  use GenServer
  @name {:global, __MODULE__}
  @store Kvdb.Store

  def start_link(db \\ %{}) do
    GenServer.start_link(__MODULE__, db, name: @name)
  end

  def get(key) do
    GenServer.call(@name, {:get, key})
  end

  def put({_, _} = kv) do
    GenServer.cast(@name, {:put, kv})
  end

  def put(key, value) do
    GenServer.cast(@name, {:put, {key, value}})
  end

  def replace({_, _} = kv) do
    GenServer.cast(@name, {:replace, kv})
  end

  def replace(key, value) do
    GenServer.cast(@name, {:replace, {key, value}})
  end

  @impl true
  def init(d) do
    IO.puts(inspect(d))
    case :ets.lookup(@store, :store) do
      [{_, stored_db}] -> {:ok, stored_db}
      _ -> {:ok, %{}}
    end
  end

  @impl true
  def terminate(_reason, state) do
    :ets.insert(@store, {:store, state})
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    case Map.fetch(state, key) do
      {:ok, val} -> {:reply, {:ok, val}, state}
      :error -> {:reply, :error, state}
    end
  end

  @impl true
  def handle_cast({:put, {k, v}}, state) do
    {:noreply, Map.put(state, k, v)}
  end

  @impl true
  def handle_cast({:replace, {k, v}}, state) do
    {:noreply, Map.replace(state, k, v)}
  end

end
