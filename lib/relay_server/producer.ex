defmodule RelayServer.Producer do
  require Logger

  @spec publish(atom(), String.t()) :: :ok | {:error, any}
  def publish(action, _) when action not in ~w(GET GETA ADD DELETE)a do
    Logger.error("Invalid action type. Use (:GET, :GETA, :ADD, :DELETE)")
  end

  def publish(action, payload) do
    {:ok, conn} = AMQP.Connection.open()
    {:ok, chan} = AMQP.Channel.open(conn)

    json_payload = Jason.decode!(payload)
    json_payload = json_payload |> Map.put("action", action)
    json_payload = Jason.encode!(json_payload)

    AMQP.Basic.publish(chan, "", "relay_server_queue", json_payload)

    AMQP.Connection.close(conn)
  end
end
