defmodule PubSubTest do
  use ExUnit.Case
  doctest PubSub

  test "subscribes and broadcasts" do
    PubSub.subscribe("hello")
    PubSub.broadcast("hello", :world)
    assert_received :world
  end

  test "double subscription" do
    PubSub.subscribe("hello")
    PubSub.subscribe("hello")
    PubSub.broadcast("hello", :world)
    assert_received :world
    assert_received :world
  end

  test "does not receive messages from other topics" do
    PubSub.subscribe("hello")
    PubSub.broadcast("unknown", :world)
    refute_received :world
  end

  test "subscribes and broadcasts with multiple processes" do
    PubSub.subscribe("hello")

    Task.start_link(fn ->
      PubSub.broadcast("hello", :world)
    end)

    assert_receive :world
  end
end
