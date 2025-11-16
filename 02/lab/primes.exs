defmodule Primes do
  # MUST: x > 1 && x < n
  # SHOULD: x = sqrt(n)
  defp check_prime_aux(_, 1) do true end
  defp check_prime_aux(n, x) do
    if rem(n, x) == 0,
      do: false,
      else: check_prime_aux(n, x - 1)
  end

  # def primes_aux(^n + 1, acc) do acc end # Does not work
  defp primes_aux(n, x, acc) when x > n do acc end
  defp primes_aux(n, x, acc) do
    # Access erlang math module through :sqrt atom
    if check_prime_aux(x, x |> :math.sqrt |> trunc),
      do: primes_aux(n, x + 1, [x | acc]),
      else: primes_aux(n, x + 1, acc)
  end

  def primes(n) when n <= 1 do [] end
  def primes(2) do [2] end
  def primes(n) do
    primes_aux(n, 3, [2])
  end

  def sieve([], acc), do: acc
  def sieve([h | t], acc) do
    filtered = Enum.filter(t, fn x -> rem(x, h) != 0 end)
    sieve(filtered, [h | acc])
  end

  def primes_sieve(n) when n <= 1 do [] end
  def primes_sieve(n) do
    sieve = sieve(:lists.seq(2, n), [])
    Enum.reverse(sieve)
  end

  defp longest_seq([]) do 0 end
  defp longest_seq(l) do
    {_, _, res} = Enum.reduce(l, {1, -1, 1},
      fn(x, {cur_seq, cur_num, best_seq}) ->
        if x == cur_num do
          cur_seq = cur_seq + 1
          if cur_seq > best_seq,
            do: {cur_seq, x, cur_seq},
            else: {cur_seq, x, best_seq}
        else
          {1, x, best_seq}
        end
      end)
    res
  end

  # First version, using int to string conversion
  # def set_primes_6() do
  #   1_000_000
  #   |> primes
  #   |> Enum.filter(fn(x) -> x >= 100_000 end)
  #   |> Enum.map(
  #     fn n ->
  #       n
  #       |> to_string
  #       |> String.graphemes # Get list of chars instead of raw bitstrings
  #       |> Enum.sort
  #       |> Enum.join
  #     end)
  #   |> Enum.sort
  #   |> longest_seq
  # end

  # Second version, keeps a list of numbers instead
  # Elixir is able to recognize and sort by the inner lists as well
  def set_primes_6() do
    1_000_000
    |> primes
    |> Enum.filter(fn(x) -> x >= 100_000 end)
    |> Enum.map(
      fn n ->
        n
        |> Integer.digits
        |> Enum.sort
      end)
    |> Enum.sort
    |> longest_seq
  end
end

# IO.puts(Primes.set_primes_6())
