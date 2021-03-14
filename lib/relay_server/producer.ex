defmodule RelayServer.Producer do
  require Logger

  @spec send(String.t(), String.t()) :: :ok | {:error, any}
  def send(action, _) when action not in ~w(GET GETA ADD DELETE) do
    Logger.error("Invalid action type. Use (GET, GETA, ADD, DELETE)")
  end

  def send(action, message) do
    {:ok, conn} = AMQP.Connection.open()
    {:ok, chan} = AMQP.Channel.open(conn)

    AMQP.Basic.publish(chan, "", "relay_server_queue", "#{action} #{message}")

    AMQP.Connection.close(conn)
  end
end
