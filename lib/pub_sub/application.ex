defmodule PubSub.Remote do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def handle_info({:broadcast, topic, message}, state) do
    PubSub.local_broadcast(topic, message)
    {:noreply, state}
  end
end

defmodule PubSub.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    registry_opts = [partitions: System.schedulers_online]

    children = [
      supervisor(Registry, [:duplicate, PubSub.Registry, registry_opts]),
      worker(PubSub.Remote, [])
    ]

    opts = [strategy: :one_for_all, name: PubSub.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
