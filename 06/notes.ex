Node.connect(:bart@coqueiroseco)
Node.list # Automatically removed if iex is closed

Node.ping(:monty@coqueiroseco) # Returns :pang if doesnt exist, :pong if it does

# Code ran in the other node, but the OUTPUT is always given to the group leader
# Group leader is the one that spawned the process
Node.spawn(:bart@coqueiroseco, fn -> IO.puts("Hello from #{node}") end)

# Code so the result is processed somewhere and sent back to the sender
f = fn x ->
  pid = self()
  fn -> send(pid, x * x) end
end
Node.spawn(:bart@coqueiroseco, f.(3))

Process.register(self(), :shell)
send(:shell, hello)
# flush()

# Send a message to a process in another node
send({:shell, :bart@coqueiroseco}, "world")

# Global registration
# Args in opposite order than Process.register/2
:global.register_name(:hell, self())
:global.whereis_name(:hell)
send(:global.whereis_name(:hell), "goodbye world")
send(:global.whereis_name(:hell), fn x -> x * x end)

# m = defmodule M do def f(x), do: x * x end
# x = :erlang.term_to_binary(m)
# send(:global.whereis_name(m), x)

# * Ping before using global servers
