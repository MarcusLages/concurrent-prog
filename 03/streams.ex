# Not lazy, time/space consuming
1..1_000_000
|> Enum.map(&(&1 * &1))
|> Enum.filter(&(rem(&1, 12) == 0))
|> Enum.sum

# Lazy
1..1_000_000
|> Stream.map(&(&1 * &1))
|> Stream.filter(&(rem(&1, 12) == 0))
|> Enum.sum

# Infinite stream that cycles
Stream.cycle([1, 2, 3])
Stream.cycle([1, 2, 3]) |> Enum.take(10)

Stream.iterate(1, &(&1 + 1)) |> Enum.take(10)

Stream.unfold({0, 1}, fn {a, b} -> {a, {b, a + b}} end)

f = Stream.cycle(["", "", "fizz"])
b = Stream.cycle(["", "", "", "", "buzz"])
n = Stream.iterate(1, &(&1 + 1))

fb = Stream.zip_with([n, f, b],
  fn [n, f, b] ->
    if f == "" && b == "", do: n, else: f <> b
  end)
