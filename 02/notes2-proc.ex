# Creates process and returns the PID
spawn(fn -> Process.sleep(2000); IO.puts("hello") end)

slow = fn x ->
  Process.sleep(2000)
  IO.puts(x)
end

Enum.each(1..5, slow)

spawn_slow. = fn x ->
  # Calling anonymous functionsyou need a dot
  spawn(slow.(1))
end
Enum.each(1..5, spawn_slow)

# PID of current process
self

# Send a message to the mailbox of the recipient
# Automatic in the console, but you need to call receive for all other things
send(self(), "hello")

send(self(), :atom)
receive do
  x -> x
end

# Send the slow function
send(self(), slow)
receive do x -> x.(2) end

send(self(), "hello")
# IN THE iex SHELL
# flush just receives all the messages all at once
flush
