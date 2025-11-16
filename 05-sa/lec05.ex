defmodule Lec5 do
  def if_fn(condition, do_block, else_block) do
    cond do
      condition -> do_block
      true -> else_block
    end
  end

  # defmacro
  # The AST of the argument is passed in, instead of value or reference
  # Lazy evaluation, in some sense
  # Also returns an AST
  defmacro inspect(expr) do
    IO.inspect(expr)
  end

  defmacro if_macro(condition, do_block, else_block) do
    quote do
      cond do
        unquote(condition) -> unquote(do_block)
        true -> unquote(else_block)
      end
    end
  end

  defmacro if(condition, do: do_block, else: else_block) do
    quote do
      cond do
        unquote(condition) -> unquote(do_block)
        true -> unquote(else_block)
      end
    end
  end

  defmacro if(condition, do: do_block) do
    quote do
      cond do
        unquote(condition) -> unquote(do_block)
        true -> nil
      end
    end
  end

  defmacro while(condition, do: block) do
    quote do
      try do
        for _ <- Stream.cycle([:ok]) do
            cond do
              unquote(condition) -> unquote(block)
              true -> throw(:break)
            end
          end
      catch :throw, :break -> :ok
      end
    end
  end

  def break, do: throw :break

  defmacro context() do
    # Macro context
    # Stuff before the AST is returned in a macro
    # Ran during compilation of context (macro expansion)
    IO.puts("Macro's context: #{__MODULE__}")

    # Caller's context
    quote do
      IO.puts("Caller's context: #{__MODULE__}")
    end
  end

  defmacro add_say_fn(name) do
    name = String.to_atom("say_" <> msg)
    quote do
      def unquote(name)() do
        IO.puts(unquote(msg))
      end
    end
  end

  Lec5.add_say_fn("hell")

end

defmodule Lec5.Tests do
  require Lec5

  def test_while() do
    pid = spawn(fn -> Process.sleep(20_000) end)
    Lec5.while Process.alive?(pid), do: (IO.puts("*"); Process.sleep(1_000))
  end

  def test_context() do
    Lec5.context()
  end
end

defmodule Example do
  # Unquote fragment on def
  # Programmatically generate a function for each
  for {k, v} <- [homer: 25, bart: 66] do
    # def is already a macro, so you can use unquote
    def unquote(k)(), do: unquote(v)
  end
end

# # Require the module before executing it
# require Lec5
# Lec5.inspect(1 + 1)

# x = 1
# # quote do -> give me the AST
# # Returns AST with 1 + x, not the value of x
# quote do: 1 + x

# # unquote() -> evaluate this AST
# # Returns AST with 1 + 1, evaluates the value of x with unquote
# # unquote can only be used inside quote
# quote do: 1 + unquote(x)

# # AST literals
# quote do: 1
# quote do: "hello"
# quote do: [1, 2.3, "hello"] # Lists that include only AST literals
# quote do: {1, "a"} # Only pairs.
# quote do: {1, "a", 3} # NOT A LITERAL ANYMORE
