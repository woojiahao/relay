defmodule RelayServer.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {RelayServer.Queue, name: Relay.Queue},
      {RelayServer.Client, name: Relay.Client}
    ]

    opts = [strategy: :one_for_one, name: RelayServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
