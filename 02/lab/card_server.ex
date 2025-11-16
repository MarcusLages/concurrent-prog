defmodule CardServer do

  def start() do
    Process.register(
      spawn(fn -> loop(new_deck()) end),
      __MODULE__
    )
  end

  defp loop(deck) do
    # Continue receiving messages from the mailbox
    receive do
      :shuffle ->
        deck = Enum.shuffle(deck)
        loop(deck)
      :new ->
        deck = new_deck()
        loop(deck)
      {:count, caller} ->
        c = Enum.count(deck)
        send(caller, c)
        loop(deck)
      {:deal, n, caller} ->
        case deal_cards(n, deck) do
          res = {:error, _} ->
            send(caller, res)
            loop(deck)
          {:ok, {hand, deck}} ->
            send(caller, {:ok, hand})
            loop(deck)
        end
    end
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

    # First intuition using reduces (fold_left)
    # Enum.reduce(ranks, [], fn(rank, acc1) ->
    #   Enum.reduce(suits, acc1, fn(suit, acc2) ->
    #     # Concat strings and list
    #     [rank <> suit | acc2]
    #   end)
    # end)

    # Second intuition using comprehensions
    for rank <- ranks, suit <- suits do
      rank <> suit
    end
  end

  def new() do
    send(__MODULE__, :new)
  end

  def shuffle() do
    send(__MODULE__, :shuffle)
  end

  def count() do
    send(__MODULE__, {:count, self()})
    receive do
      n -> n
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

  def deal(n \\ 1) do
    send(__MODULE__, {:deal, n, self()})
    receive do
      hand -> hand
    end
  end

end
