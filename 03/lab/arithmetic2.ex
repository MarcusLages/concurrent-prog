defmodule Arithmetic.Worker do
  use GenServer

  def start() do
    GenServer.start(__MODULE__, nil)
  end

  @impl true
  def init(arg) do {:ok, arg} end

  @impl true
  def handle_call({:square, x}, _from, state) do
    Process.sleep(4000)
    {:reply, {self(), x * x}, state}
  end

  @impl true
  def handle_call({:sqrt, x}, _from, state) do
    Process.sleep(4000)
    res = if x < 0,
      do:
        {self(), :error},
      else:
        {self(), :math.sqrt(x)}
    {:reply, res, state}
  end

  def square(pid, x) do
    GenServer.call(pid, {:square, x})
  end

  def sqrt(pid, x) do
    GenServer.call(pid, {:sqrt, x})
  end

end

defmodule Arithmetic.Server do
  use GenServer

  def start(workers \\ 1) do
    if workers < 1, do: :error,
    else: GenServer.start(__MODULE__, start_workers(workers), name: {:global, __MODULE__})
  end

  defp start_workers(0, acc) do acc end
  defp start_workers(n, acc) do
    {_, worker} = Arithmetic.Worker.start()
    start_workers(n - 1, [worker | acc])
  end
  defp start_workers(n) do
    start_workers(n, [])
  end

  @impl true
  def init(arg) do {:ok, arg} end

  @impl true
  def handle_call(:get_worker, _from, [h | t]) do
    {:reply, h, t ++ [h]}
  end

  def square(x) do
    worker = GenServer.call({:global, __MODULE__}, :get_worker)
    Arithmetic.Worker.square(worker, x)
  end

  def sqrt(x) do
    worker = GenServer.call({:global, __MODULE__}, :get_worker)
    Arithmetic.Worker.sqrt(worker, x)
  end

end

# alias Arithmetic.Worker
# alias Arithmetic.Server
