# How to implement a generic server
# Limited of server: only works with requests that need a response back
defmodule GenericServer do
  # m is a module
  # init is the initial value/state
  def start(m, init) do
    spawn(fn -> loop(m, init) end)
  end

  def call(pid, msg) do
    send(pid, {self(), msg})
    receive do
      x -> x
    end
  end

  defp loop(m, state()) do
    receive do
      {from, msg} ->
        {response, new_state} = m.handle_call(msg, from, state)
        send(from, response)
        loop(m, new_state)
    end
  end

end

defmodule ArithmeticServer do
  def start() do
    GenericServer.start(__MODULE__, nil)
  end

  def square() do
    GenericServer.call(pid, {:square, x})
  end

  def sqrt() do
    GenericServer.call(pid, {:sqrt, x})
  end

  # Underscore means we are not using the from (_from)
  def handle_call({:square, x}, _from, state) do
    {x * x, state}
  end

  def handle_call({:sqrt, x}, _from, state) do
    response = if x < 0, do: error, else: {:math.sqrt(x), state}
  end

end

defmodule CounterServer1 do
  def start(n \\ 0) do
    GenericServer.start(__MODULE__, n)
  end

  def inc(pid) do
    GenericServer.call(pid, :inc)
  end

  def handle_call(:inc, _from, state) do
    {state + 1, state + 1}
  end
end

# More generic server
defmodule GenericServerV2 do
  def start(m, arg) do
    # ! MUST implement init function on the next servers
    state = init(arg)
    spawn(fn -> loop(m, init) end)
  end

  defp loop(m, state) do
    receive do
      {:call, from, msg} ->
        {response, new_state} = m.handle_call(msg, from, state)
        send(from, response)
        loop(m, new_state)
      {:cast, msg} ->
        new_state = m.handle_cast(msg, state)
        loop(m, new_state)
    end
  end
end

defmodule CounterServer do
  def start(n \\ 0) do
    GenericServerV2.start(__MODULE__, n)
  end

  def init(arg) do arg end

  def inc(pid) do
    GenericServerV2.cast(pid, :inc)
  end

  def value(pid) do
    GenericServerV2.call(pid, :value)
  end

  def handle_call(:value, _from, state) do
    {state, state}
  end

  def handle_cast(:value, state) do
    state + 1
  end
end
