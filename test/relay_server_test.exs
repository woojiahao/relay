defmodule RelayServerTest do
  use ExUnit.Case
  doctest RelayServer

  test "greets the world" do
    assert RelayServer.hello() == :world
  end
end
