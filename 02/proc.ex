defmodule ArithmeticServer do
  # Start function to start the server and start a process
  # Sends back pid of process
  def start() do
    spawn(&loop/0)
  end

  defp loop() do
    receive do
      {:square, x, from} ->
        send(from, x * x)
      {:sqrt, x, from} ->
        response =
          if x < 0, do: :error, else: :math.sqrt()
        # Send response + server pid
        send(from, {self(), response})
      _ -> :ok # Throw away random messages
    end
    loop()
  end

  def square(pid, x) do
    send(pid, {:square, x, self()})
    receive do
      # Makes sure that this pid matches the local pid variable
      {^pid, x} -> x
    end
  end

  def sqrt(pid, x) do
    send(pid, {:sqrt, x, self()})
    receive do
      {^pid, :error} -> "No square root"
      {^pid, x} -> x
    end
  end

end
alias ArithmeticServer, as: AS

defmodule CounterServer do
  def start() do
    loop(0)
  end

  defp loop(n) do
    receive do
      :inc ->
        loop(n + 1)
      {:value, from} ->
        send(from, n)
        loop(n)
    end
  end

  def inc(pid) do
    send(pid, :inc)
  end

  def value(pid) do
    send(pid, {:value, pid})
    receive do
      x -> x
    end
  end
end
alias CounterServer, as: CS

defmodule RegisteredCounterServer do
  # Default value to 0
  # Can be used as function prototype
  def start(n \\ 0) do
    Process.register(spawn(fn -> loop(n) end), __MODULE__)
  end

  defp loop(n) do
    receive do
      :inc ->
        loop(n + 1)
      {:value, from} ->
        send(from, n)
        loop(n)
    end
  end

  def inc() do
    send(__MODULE__, :inc)
  end
  
  def value() do
    send(__MODULE__, {:value, self()})
    receive do
      x -> x
    end
  end
end
