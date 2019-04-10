defmodule JagerTest do
  use ExUnit.Case
  doctest Jager

  test "greets the world" do
    assert Jager.hello() == :world
  end
end
