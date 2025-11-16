defmodule Card.Store do
  use GenServer

  def start_link(filename \\ "cards.db") do
    GenServer.start_link(__MODULE__, filename, name: __MODULE__)
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def put(val) do
    GenServer.cast(__MODULE__, {:put, val})
  end

  @impl true
  def init(filename) do
    {:ok, filename}
  end

  @impl true
  def handle_call(:get, _from, filename) do
    res =
      case File.read(filename) do
        {:ok, bin} -> :erlang.binary_to_term(bin)
        _ -> nil
      end
    {:reply, res, filename}
  end

  @impl true
  def handle_cast({:put, val}, filename) do
    File.write(filename, :erlang.term_to_binary(val))
  end

end
