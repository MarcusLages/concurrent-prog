defmodule Card.Worker do
  use GenServer
  @store Card.Store

  def start_link(name) do
    GenServer.start_link(__MODULE__, nil, name: via(name))
  end

  def via(name) do
    {:via, Registry, {Card.Registry, {__MODULE__, name}}}
  end

  defp new_deck() do
    ranks = for x <- 2..14 do
      case x do
        11 -> "J"
        12 -> "Q"
        13 -> "K"
        14 -> "A"
        _ -> to_string(x)
      end
    end
    suits = ["♣", "♦", "♥", "♠"]

    for rank <- ranks, suit <- suits do
      rank <> suit
    end
  end

  def deal_cards(n, deck) do
    count = Enum.count(deck)
    cond do
      n > count -> {:error, "Insufficient cards in deck."}
      n < 0 -> {:error, "Invalid amount. Can only draw a non-negative amount of cards."}
      count == 0 -> {:error, "Empty deck."}
      true -> {:ok, Enum.split(deck, n)}
    end
  end

  def new(name) do
    GenServer.cast(via(name), :new)
  end

  def shuffle(name) do
    GenServer.cast(via(name), :shuffle)
  end

  def count(name) do
    GenServer.call(via(name), :count)
  end

  def deal(name, n \\ 1) do
    GenServer.call(via(name), {:deal, n})
  end

  @impl true
  def init(name) do
    IO.puts(" ==== Card Worker server(#{inspect(self())}) starting... ==== ")
    name = {__MODULE__, name}
    deck =
      case :ets.lookup(@store, name) do
        [] -> new_deck()
        [{_, stored_deck}] -> stored_deck
      end
    { :ok, {name, deck} }
  end

  @impl true
  def handle_cast(:new, {name, _}) do
    {:noreply, {name, new_deck()}}
  end

  @impl true
  def handle_cast(:shuffle, {name, deck}) do
    {:noreply, {name, Enum.shuffle(deck)}}
  end

  @impl true
  def handle_call(:count, _from, {_, deck} = state) do
    {:reply, Enum.count(deck), state}
  end

  @impl true
  def handle_call({:deal, n}, _from, {name, deck} = state) when is_integer(n) do
    case deal_cards(n, deck) do
      res = {:error, _} -> {:reply, res, state}
      {:ok, {hand, new_deck}} -> {:reply, {:ok, hand}, {name, new_deck}}
    end
  end

  @impl true
  def terminate(_reason, state) do
    :ets.insert(@store, state)
  end
end

defmodule Test do
  def test1() do
    Card.WorkerSupervisor.start_worker("w1")
    Card.Worker.deal("w1", 5)
    Card.Worker.deal("w1", :bruh)
  end
  def test2() do
    Card.Worker.count("w1")
  end
end
