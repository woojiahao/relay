# RelayServer

Demonstration of a use case of [Broadway](https://github.com/dashbitco/broadway) by creating a HTTP-replica that relays
commands issued by a client to a message queue.

Relayed commands are consumed by the message broker and processed by the server, with appropriate responses being sent
back to the client.

The relay server acts as a bank for simple NPCs -- including their names, ages, and favorite foods.

In many ways, it is an upgraded version of the OTP example from the Elixir documentation 
[here](https://elixir-lang.org/getting-started/mix-otp/genserver.html).

## Requests

For the sake of simplicity, the relay server will only accept the following requests:

1. `add(<name>, <age>, <favorite food>)` - creates a new character to add to the bank
2. `delete(<name>)` - deletes a character from the bank
3. `get(<name>)` - retrieves a character from the bank
4. `get_all()` - retrieves all character information from the bank -- intentionally sent as a batch request
5. `update(<name>, age: <age>, favorite_food: <favorite food>)` - update a character

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

Run the project. This starts the server and client simultaneously.

```bash
iex -S mix
```

```elixir
{ :ok, john } = RelayServer.Client.add("John Doe", 27, "Pasta")
{ :ok, mary } = RelayServer.Client.add("Mary Anne", 19, "Pepperoni Pizza")
characters = RelayServer.Client.get_all()
IO.puts(inspect(characters))
:ok = RelayServer.Client.delete("Mary Anne")
characters = RelayServer.Client.get_all()
IO.puts(inspect(characters))
```
