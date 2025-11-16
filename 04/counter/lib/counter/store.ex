defmodule Counter.Store do
  use GenServer

  def start_link(filename \\ "store.db") do
    GenServer.start_link(__MODULE__, filename, name: __MODULE__)
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def put(value) do
    GenServer.cast(__MODULE__, {:put, value})
  end

  @impl true
  def init(filename) do
    {:ok, filename}
  end

  @impl true
  def handle_call(:get, _from, filename) do
    reply =
      case File.read(filename) do
        {:ok, bin} ->
          :erlang.binary_to_term(bin)
        _ -> nil
    {:reply, reply, filename}
    end
  end

  @impl true
  def handle_cast(:put, filename) do
    File.write(filename, :erlang.term_to_binary(value))
  end

end

# File.write("abc", <<1, 2, 3>>)
# File.read("abc")
# bin = :erlang.term_to_binary({1, "hello", [3, :abc]})
# File.write("abc", bin)
# {:ok, bin} = File.read()
# term = :erlang.binary_to_term(bin)
