defmodule Card.Worker do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
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

  def new() do
    GenServer.cast(__MODULE__, :new)
  end

  def shuffle() do
    GenServer.cast(__MODULE__, :shuffle)
  end

  def count() do
    GenServer.call(__MODULE__, :count)
  end

  def deal(n \\ 1) do
    GenServer.call(__MODULE__, {:deal, n})
  end

  @impl true
  def init(_) do
    IO.puts(" ==== Card server starting... ==== ")
    { :ok, Card.Store.get() || new_deck() }
  end

  @impl true
  def handle_cast(:new, _state) do
    {:noreply, new_deck()}
  end

  @impl true
  def handle_cast(:shuffle, state) do
    {:noreply, Enum.shuffle(state)}
  end

  @impl true
  def handle_call(:count, _from, state) do
    {:reply, Enum.count(state), state}
  end

  @impl true
  def handle_call({:deal, n}, _from, state) when is_integer(n) do
    case deal_cards(n, state) do
      res = {:error, _} -> {:reply, res, state}
      {:ok, {hand, deck}} -> {:reply, {:ok, hand}, deck}
    end
  end

  @impl true
  def terminate(_reason, state) do
    Card.Store.put(state)
  end
end
