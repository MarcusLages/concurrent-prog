# Map. Key-value pair
m = %{:monty => 99, "homer" => 25, "bart" => 25}

# If it doesn't exist, returns nil
h = m["homer"]
h = m["sefdsdhomer"]

# If all keys are atoms, it's displayed without the front collon (:)
m = %{:monty => 99, :homer => 25, :bart => 25}

m[:monty]
m.monty # Only for when all keys are atoms

# Update (only atoms)
%{m | homer: 60}

Map.get(m, :monty, -1)
Map.get(m, :lisa, -1)
Map.put(m, :lisa, 70)

# Bit string
# Binary 9 -> First 3 bits
# Binary 11 -> First 5 bits
<<9::3, 11::5>>

# One byte for each if there's no collons
<<1, 2, 3>>

# x = <<11::size(5)>>
<<_::3, x::bitstring>> = <<43>>

<<43::size(5)>> == <<11::5>>

# Get second character of a string
<<_, x, rest::binary>> = "hello"

# Checks the bytecode of a character
?h

# Check the charset numbers of a string
~c"asdas"

"\u2660"
to_string [0x2660]

Integer.to_string(9824, 16)

x = 1..5    # Range from 1 to 5 included
x = [1..5]  # list that CONTAINS a range from 1 to 5 included

for x <- [3, 2, 7, 6, 8], rem(x, 3) != 0, do: x
for {k, v} <- m2, v >= 50, do: v

# The thing that is piped is piped to the first argument
(for {k, v} <- m2, v >= 50, do: v) |> Enum.sum
[1, 2, 3] |> Enum.map(&(&1 * &1)) |> Enum.sum

# Bit string generators
for <<c::1 <- <<0x39>> >>, do: c
for <<c::1 <- <<0x39>> >>, into: <<>>, do: <<c>> # Each bit string becomes a byte
for <<c::1 <- <<0x39>> >>, into: <<>>, do: <<c::1>> # Each bit string becomes a bit

for <<c <- "hello world">>, do: c
for <<c <- "hello world  ">>, c != ?\s, into: "", do: <<c>>

for {k, 100} <- [homer: 22, bart: 55, monty: 100], do: k

to_string(:homer)
