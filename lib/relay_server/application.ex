defmodule RelayServer.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {RelayServer.Queue, name: Queue},
      {RelayServer.Server, name: Server},
      {RelayServer.Client, name: Client}
    ]

    opts = [strategy: :one_for_one, name: RelayServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
