defmodule Testing do
  defmacro check(predicate) do
    name = MACRO.to_string(predicate)
    quote do
      cond do
        unquote(predicate) -> IO.puts("Passed ... #{unquote(name)}")
        true -> IO.puts("Failed ... #{unquote(name)}")
      end
    end
  end

  defmacro test(name, do: block) do
    title = "test_" <> name
    name = String.to_atom(title)
    quote do
      @tests [unquote(name) | @tests]
      def unquote(name)() do
        IO.puts(unquote(title) <> ":")
        unquote(block)
      end
    end
  end

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      # Attribute
      @tests []
    end
  end

  defmacro make_run() do
    quote do
      @tests
      |> Enum.reverse
      |> Enum.each(fn f -> apply(__MODULE__, f, []) end)
    end
  end
end

defmodule Testing.Tests do
  # use is a macro that calls __using__ in that module
  use Testing
  # require Testing

  test "equality" do
    check(1 + 1 == 2)
    check(1 + 2 == 2)
  end

  test "inequality" do
    check(1 + 1 != 1)
  end

end
