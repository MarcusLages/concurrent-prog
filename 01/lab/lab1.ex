# Marcus Vinicius Santos Lages
# A01392327
defmodule Lab1 do
  defp inverse_mod(_, n, r, newr, t, _) when newr == 0 do
    if r > 1 do
      :not_invertible
    else if t < 0 do
      t + n
    else
      t
    end
    end
  end
  defp inverse_mod(a, n, r, newr, t, newt) do
    q = div(r, newr)
    inverse_mod(a, n, newr, r - q * newr, newt, t - q * newt)
  end
  def inverse_mod(a, n) do
    inverse_mod(a, n, n, a, 0, 1)
  end

  defp pow_mod(_, 0, _, acc) do acc end
  defp pow_mod(a, m, n, acc) do
    am = rem(a, n)
    new_acc = rem(acc * am, n)
    pow_mod(a, (m - 1), n, new_acc)
  end
  def pow_mod(a, m, n) do
    pow_mod(a, m, n, 1)
  end
end
