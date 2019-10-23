defmodule PersistTest do
  use ExUnit.Case
  doctest Persist

  test "greets the world" do
    assert Persist.hello() == :world
  end
end
