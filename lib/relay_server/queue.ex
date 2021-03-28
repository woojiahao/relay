defmodule RelayServer.Queue do
  use Broadway

  alias Broadway.Message, warn: false

  require Logger

  @server_proc Server

  def start_link(_opts) do
    IO.puts("Starting queue manager...")

    :ok =
      :telemetry.attach(
        "handle-message-handler",
        [:broadway, :processor, :stop],
        &RelayServer.Handler.handle_event/4,
        nil
      )

    Broadway.start_link(__MODULE__,
      name: RelayServer.Queue,
      producer: [
        module: {
          BroadwayRabbitMQ.Producer,
          queue: "relay_server_queue", qos: [prefetch_count: 50]
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
    process_message(message)
    message
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    messages
  end

  @spec process_message(Message.t()) :: any()
  defp process_message(message) do
    payload = Jason.decode!(message.data)
    action = payload["action"] |> String.to_atom()

    case action do
      :GETA ->
        characters = GenServer.call(@server_proc, :get_all)
        characters |> Enum.each(&IO.puts(IO.inspect(&1)))

      :GET ->
        name = payload["name"]
        character = GenServer.call(@server_proc, {:get, name})
        IO.puts(IO.inspect(character))

      :ADD ->
        %{
          "name" => name,
          "age" => age,
          "favorite_food" => favorite_food
        } = payload

        GenServer.cast(@server_proc, {:add, name, age, favorite_food})

        IO.puts("Created character #{name}")

      :DELETE ->
        name = payload["name"]
        GenServer.cast(@server_proc, {:delete, name})
        IO.puts("Deleted character #{name}")

      _ ->
        Logger.error("Invalid action type.")
    end
  end
end
