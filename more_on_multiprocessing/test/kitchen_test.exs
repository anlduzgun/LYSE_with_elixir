defmodule KitchenTest do
  use ExUnit.Case
  doctest Kitchen

  test "greets the world" do
    assert Kitchen.hello() == :world
  end
end
