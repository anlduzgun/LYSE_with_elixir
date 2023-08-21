defmodule KittyGenServerTest do
  use ExUnit.Case
  doctest KittyGenServer

  test "greets the world" do
    assert KittyGenServer.hello() == :world
  end
end
