defmodule Lec4 do
  # Spawn n processes that keep executing loop
  def create(n \\ 4) do
    Enum.map(1..n, fn _ -> pid = self; spawn(fn -> loop(pid) end) end)
    # Enum.map(1..n, fn _ ->
    #   pid = self
    #   spawn(fn -> loop(pid) end)
    # end)
  end

  def trap_exit(pid) do
    send(pid, :trap_exit)
  end

  def no_trap_exit(pid) do
    send(pid, :no_trap_exit)
  end

  def link(pid, other) do
    send(pid, {:link, other})
  end

  # Check if only one pid
  def info(pid) when is_pid(pid) do
    if Process.alive?(pid) do
      # pid followed by keyword list
      {pid, [{:alive, true},
        Process.info(pid, :trap_exit),
        Process.info(pid, :link)]}
    else
      {pid, [:alive, false]}
    end
  end

  def info(pids) do
    Enum.map(pids, &info/1)
  end

  defp loop(parent) do
    receive do
      # The own process can trap an exit signal using Process.flag
      # With this flag, it won't kill the process with a Process.kill
      # Only exception is Process.exit(p1, :kill)
      :trap_exit ->
        Process.flag(:trap_exit, true)
      :no_trap_exit ->
        Process.flag(:trap_exit, false)
      # Links processes so they have conscious of each other
      # If a process in the link dies, it will send an exit signal to all of
      # the linked signals with the cause of death, possibly causing a propagation
      # of process kills
      # Bidirectional (is added to both linked processes
      {:link, other} ->
        Process.link(other)
      x -> send(parent, {self(), x})
    end
    loop(parent)
  end

end
