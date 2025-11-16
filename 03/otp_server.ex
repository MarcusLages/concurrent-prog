# We call it a worker because it will be supervised later
defmodule Arithmetic.Worker do
  use GenServer   # Called a behaviour. Use is a macro that imports something

  def start() do
    GenServer.start(__MODULE__, nil)
  end

  # Doesn't follow common response std by the documentation
  # def init(arg) do arg end

  # Implementation attribute
  # Allows elixir to check for its compilation so it agrees to the callback
  # Kind of like checking if all interface functions are implemented
  @impl true
  def init(arg) do {:ok, arg} end

  @impl true
  def handle_call({:square, x}, _from, state) do
    {:reply, x * xf, state}
  end

  @impl true
  def handle_call({:sqrt, x}, _from, state) do
    {:reply, (if x < 0, do: :error, else: :math.sqrt(x)), state}
  end

  # Client API entry point calls

  def square(pid, x) do
    GenServer.call(pid, {:square, x})
  end

  def sqrt(pid, x) do
    GenServer.call(pid, {:sqrt, x})
  end

end
alias Arithmetic.Worker # Alias becomes Worker
