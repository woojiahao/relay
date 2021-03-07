defmodule RelayServer.Queue do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: RelayServer.Queue,
      producer: [
        module: {
          BroadwayRabbitMQ.Producer,
          queue: "relay_server_queue", qos: [prefetch_count: 1]
        }
      ],
      processors: [
        default: [
          concurrency: 50
        ]
      ],
      batchers: [
        default: [
          batch_size: 10,
          batch_timeout: 1500,
          concurrency: 5
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, message, _) do
    message
    |> Message.update_data(fn data -> {data, String.to_integer(data) * 2} end)
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    list = messages |> Enum.map(& &1.data)
    IO.inspect(list, label: "Got batch")
    messages
  end
end
