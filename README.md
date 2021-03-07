# RelayServer

Demonstration of a use case of [Broadway](https://github.com/dashbitco/broadway) by creating a HTTP-replica that relays
commands issued by a client to a message queue.

Relayed commands are consumed by the message broker and processed by the server, with appropriate responses being sent
back to the client.

The relay server acts as a bank for simple NPCs -- including their names, ages, and favorite foods.

## Requests

For the sake of simplicity, the relay server will only accept the following requests:

1. `ADD <name> <age> <favorite food>` - creates a new character to add to the bank
2. `DLT <name>` - deletes a character from the bank
3. `GET <name>` - retrieves a character from the bank
4. `ALL` - retrieves all character information from the bank -- intentionally sent as a batch request


## Usage

Ensure that you have RabbitMQ installed.

Create a new queue in RabbitMQ.

```bash
rabbitmqadmin declare queue name=relay_server_queue durable=true
```

Set up the project.

```bash
git clone https://github.com/woojiahao/relay.git
cd relay/
mix deps.get
```

Run the project. This starts the server automatically. Clients have to be created manually.

```bash
iex -S mix
```

Create a new client connection and start making requests.

```elixir
client = RelayServer.Client.new
{ :ok, john } = client.add("John Doe", 27, "Pasta")
{ :ok, mary } = client.add("Mary Anne", 19, "Pepperoni Pizza")
characters = client.get_all()
IO.puts(inspect(characters))
:ok = client.delete("Mary Anne")
characters = client.get_all()
IO.puts(inspect(characters))
```