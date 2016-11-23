defmodule PubSub do
  @moduledoc """
  Documentation for PubSub.
  """

  def subscribe(topic) do
    Registry.register(PubSub.Registry, topic, nil)
  end

  def broadcast(topic, msg) do
    remote_broadcast(topic, msg)
    local_broadcast(topic, msg)
  end

  def remote_broadcast(topic, msg) do
    for node <- Node.list do
      send({PubSub.Remote, node}, {:broadcast, topic, msg})
    end
  end

  def local_broadcast(topic, msg) do
    Registry.dispatch(PubSub.Registry, topic, fn pids_with_values ->
      for {pid, _} <- pids_with_values do
        send(pid, msg)
      end
    end)
    :ok
  end
end
