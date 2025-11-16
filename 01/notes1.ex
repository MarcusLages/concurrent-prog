defmodule Lec1 do
	def fact(n) do
		if n <= 0, do: 1, else: n * fact(n - 1)
	end

	defp fact2(0, acc) do acc end
	defp fact2(n, acc) do fact2(n-1, n * acc) end
	def fact2(n) do fact2(n, 1) end

	def fact3(n) do
        # Special form constructs like if, case, else, ...
		# same as: if(n <= 0, [do: 1, else: n * fact3(n - 1)])
		# same as: if(n <= 0, [{do, 1}, {else, n * fact3(n - 1)}])
        # ! Those constructs only work if the term is only one line
		if n <= 0, do: 1, else: n * fact3(n - 1)
	end

    # def dedup(l) do
    #     case l do
    #         [h1, h2 | t] ->
    #             if h1 == h2, do: dedup([h2|t]), else: dedup(h1|[h2|t])
    #         _ -> l
    #     end
    # end

    def dedup(l) do
        case l do
            [h1, x = [h2, _]] ->
                if h1 == h2, do: dedup(x), else: h1 | dedup(x)
            _ -> l
        end
    end

    def dedup2(l) do
        [h, h | t] -> dedup2([h | t])
        [h | t] -> [h | dedup2(t)]
        _ -> l
    end

    defp print(n) do
        cond do     #conditional do
          rem(n, 15) == 0 -> IO.puts("fizzbuzz")
          rem(n, 5) == 0 -> IO.puts("buzz")
          rem(n, 3) == 0 -> IO.puts("fizz")
          true -> IO.puts(n)
        end
    end

    defp fizzbuzz(1, n) when i > n, do: :ok #returns :ok as a side effect
    defp fizzbuzz(1, n) do
        print(i)
        fizzbuzz(i + 1, n)
    end
    def fizzbuzz(n), do: fizzbuzz(1, n)

    # Ampersand (&): capture a function
    #   &fun/arity_number
    #   &+/2 or &(&1 + &2)
    # 1..n: range, 1 to n
    def fizzbuzz2(n), do: Enum.each(1..n, &print/1)

    # Range comprehension with do as macro
    # 1. Using case do with pattern matching
    ranks = for x <- 2..14, do:
    case x do
        11 -> "J"
        12 -> "Q"
        13 -> "K"
        _ -> to_string(x)
    end
    # 2. Using cond do with stacked if-elses
    ranks = for x <- 2..14,
        cond do
        x == 11 -> "J"
        x == 12 -> "Q"
        x == 13 -> "K"
        true -> to_string(x)
        end

end

# Enum.map([3,2,7,6,4], &IO.puts/1)
