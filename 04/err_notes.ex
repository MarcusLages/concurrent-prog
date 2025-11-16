# Errors, Exits and Throws
try do
  1 / 0
catch type, value -> {type, value} end # {:error, :badarith}

try do
  raise "hell"
catch type, value ->
  {:error, %RuntimeError{message: "hell"}} # RuntimeError struct
end

# Stops execution
try do
  # Regular stdlib or Kernel.exit
  exit(:abc)
catch type, value -> {:exit, :abc}
end

# For control flow
try do
  throw 123
catch type, value -> {:throw, 123}
end

# Send a process an exit signal
# Process dies after, unless it's :normal
Process.exit(self(), :abc)
Process.exit(self(), :normal)

# ? used for true or false boolean
# Check if process is alive by pid
Process.alive?(self())

# Check for info on the process
Process.info(self())
Process.info(self(), :links)

# Process can track a specific signal so it doesn't die using :trap_exit flag
# Processes can only be killed by the :kill message
Process.flag(self(), :trap_exit)
Process.flag(self(), :kill)

# Processes that trap an exit transform all exit signals into a message in
# the mailbox as tuple with {:EXIT, pid of dead process, reason of death}
# To avoid the :kill signal to delete EVERYONE, if a linked process dies
# because of :kill, it is propagate as the :killed signal
