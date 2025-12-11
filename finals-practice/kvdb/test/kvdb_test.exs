defmodule KvdbTest do
  use ExUnit.Case
  doctest Kvdb

  test "greets the world" do
    assert Kvdb.hello() == :world
  end
end
