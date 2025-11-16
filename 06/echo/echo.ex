defmodule Echo.Passive do
  def start(port \\ 6666) do
    opts = [:binary, active: false, packet: :line, reuseaddr:  true]

    # Listening socket
    # When you accept the listening, you get another socket
    {:ok, listen_socket} = :gen_tcp.listen(port, opts)
    accept(listen_accept)
  end

  defp accept(listen_socket) do
    {:ok, socket} = :gen_tcp.accept(listen_socket)
    spawn(fn -> loop(socket) end)
    accept(listen_socket)
  end

  defp loop(socket) do
    case :get_tcp.recv(socket, 0) do
      {:ok, data} ->
        :gen_tcp.send(socket, data)
        loop(socket)
        {:error, _} ->
          :gen_tcp.close(socket)
    end
  end
end

# Active: everything will be put into the mail box
defmodule Echo.Active do
  def start(port \\ 6666) do
    opts = [:binary, active: true, packet: :line, reuseaddr:  true]

    # Listening socket
    # When you accept the listening, you get another socket
    {:ok, listen_socket} = :gen_tcp.listen(port, opts)
    accept(listen_accept)
  end

  defp accept(listen_socket) do
    {:ok, socket} = :get_tcp.accept(listen_socket)

    # Everything will be converted to the mailbox of the main process
    spawn(fn -> accept(listen_socket) end)
    loop(listen_socket)
  end

  def loop(socket) do
    receive do
      {:tcp, ^socket, data} ->
        :gen_tcp.send(socket, data)
        loop(socket)
      {:tcp_closed, ^socket} ->
        :gen_tcp.close(socket)
    end
  end
end

# Give flow control to the Active server
defmodule Echo.Hybrid do
  def start(port \\ 6666) do
    opts = [:binary, active: :once, packet: :line, reuseaddr:  true]

    # Listening socket
    # When you accept the listening, you get another socket
    {:ok, listen_socket} = :gen_tcp.listen(port, opts)
    accept(listen_accept)
  end

  defp accept(listen_socket) do
    {:ok, socket} = :get_tcp.accept(listen_socket)

    # Everything will be converted to the mailbox of the main process
    spawn(fn -> accept(listen_socket) end)
    loop(listen_socket)
  end

  def loop(socket) do
    receive do
      {:tcp, ^socket, data} ->
        :inet.setopts(socket, active: :once)
        :gen_tcp.send(socket, data)
        loop(socket)
      {:tcp_closed, ^socket} ->
        :gen_tcp.close(socket)
    end
  end
end

defmodule Echo.Server do
  use GenServer

  def start(port \\ 6666) do
    GenServer.start(__MODULE__, port)
  end

  @impl true
  def init(port) do
    opts = [:binary, active: :once, packet: :line, reuseaddr: true]
    case :gen_tcp.listen(port) do
      {:ok, listen_socket} ->
        send(self(), :accept)
        {:ok, listen_socket}
      {:error, reason} ->
        {:stop, reason}
    end
  end

  @impl true
  def handle_info(:accept, listen_socket) do
    case :gen_tcp.accept(listen_socket) do
      {:ok, socket} ->
        {:ok, pid} = Echo.Worker.start_link(socket)
        # So messages are delivered to the echo worker
        :gen_tcp.controlling_process(socket, pid)
        send(self(), :accept)
        {:noreply, listen_socket}
      {:error, reason} -> {:stop, reason, listen_socket}
    end
  end
end

defmodule Echo.Worker do
  use GenServer

  def start_link(socket) do
    GenServer.start_link(__MODULE__, socket)
  end

  @imnpl true
  def init(socket) do
    {:ok, socket}
  end

  @impl true
  def handle_info({:tcp, socket, data}, socket) do
    :inet.setopts(socket, active: :once)
    :gen_tcp.send(socket, data)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:tcp_closed, socket}, socket) do
    :gen_tcp.close(socket)
    {:stop, :normal, socket}
  end
end
