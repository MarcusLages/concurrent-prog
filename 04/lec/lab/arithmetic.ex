defmodule Arithmetic.Worker do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  @impl true
  def init(arg) do {:ok, arg} end

  @impl true
  def handle_call({:square, x}, _from, state) when is_number(x) do
    {:reply, {self(), x * x}, state}
  end

  @impl true
  def handle_call({:sqrt, x}, _from, state) when is_number(x) do
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
    else: GenServer.start(__MODULE__, workers, name: __MODULE__)
  end

  defp start_workers(0, acc) do acc end
  defp start_workers(n, acc) do
    {_, worker} = Arithmetic.Worker.start_link()
    start_workers(n - 1, [worker | acc])
  end
  defp start_workers(n) do
    start_workers(n, [])
  end

  @impl true
  def init(workers) do
    Process.flag(:trap_exit, true)
    {:ok, start_workers(workers)
  } end

  @impl true
  def handle_call(:get_worker, _from, [h | t]) do
    {:reply, h, t ++ [h]}
  end

  @impl true
  def handle_cast(:trap_exit, _state) do
    Process.flag(:trap_exit, true)
  end

  @impl true
  def handle_cast(:untrap_exit, _state) do
    Process.flag(:trap_exit, false)
  end

  @impl true
  def handle_info({:EXIT, pid, _}, workers) do
    {_, new_worker} = Arithmetic.Worker.start_link()
    IO.puts("New worker starting with pid " <> inspect(new_worker))
    new_workers = workers
      |> Enum.filter(fn w_pid -> w_pid != pid end)
      |> Enum.concat([new_worker])
    {:noreply, new_workers}
  end

  def square(x) do
    worker = GenServer.call(__MODULE__, :get_worker)
    Arithmetic.Worker.square(worker, x)
  end

  def sqrt(x) do
    worker = GenServer.call(__MODULE__, :get_worker)
    Arithmetic.Worker.sqrt(worker, x)
  end

  def trap_exit() do
    GenServer.cast(__MODULE__, :trap_exit)
  end

  def untrap_exit() do
    GenServer.cast(__MODULE__, :untrap_exit)
  end

end

# alias Arithmetic.Worker
# alias Arithmetic.Server
