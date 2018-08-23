defmodule ExsTest do
  use ExUnit.Case
  doctest Exs

  test "greets the world" do
    assert Exs.hello() == :world
  end
end
