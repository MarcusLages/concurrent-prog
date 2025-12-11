defmodule GenericServer do

  def start(m, init) do
    spawn(fn -> loop(m, init) end)
  end

  def loop(m, state) do
    receive do
      {from, msg} ->
        loop(m, m.handle_info(msg, from, state))
      _ -> loop(m, state)
    end
  end

  def call(pid, msg) do
    send(pid, {self(), msg})
    receive do
      x -> x
    end
  end

  def cast(pid, msg) do
    send(pid, {self(), msg})
    :ok
  end

end

defmodule CounterServer do

  def start(init \\ 0) do
    GenericServer.start(__MODULE__, init)
  end

  def handle_info({:inc, i}, _from, state) do
    state + i
  end

  def handle_info(:val, from, state) do
    send(from, state)
    state
  end

  def inc(pid, i \\ 1) do
    GenericServer.cast(pid, {:inc, i})
  end

  def val(pid) do
    GenericServer.call(pid, :val)
  end

end
