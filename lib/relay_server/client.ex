defmodule RelayServer.Client do
  @moduledoc """
  Client for the relay server
  """
  use GenServer

  def add(server, name, age, favorite_food) do
    GenServer.cast(server, {:add, name, age, favorite_food})
  end

  def delete(server, name) do
    GenServer.cast(server, {:delete, name})
  end

  def get_all(server) do
    GenServer.call(server, :get_all)
  end

  def get(server, name) do
    GenServer.call(server, {:get, name})
  end

  @impl true
  def init(:ok) do
    {:ok, []}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def handle_call({:get, name}, _from, characters) do
    matching_character =
      characters
      |> Enum.filter(&(&1.name == name))
      |> List.first()

    {:reply, matching_character, characters}
  end

  @impl true
  def handle_call(:get_all, _from, characters) do
    {:reply, characters, characters}
  end

  @impl true
  def handle_cast({:delete, name}, characters) do
    matching_character_index =
      characters
      |> Enum.find_index(&(&1.name == name))

    if not is_nil(matching_character_index) do
      {:noreply, characters |> List.delete_at(matching_character_index)}
    else
      {:noreply, characters}
    end
  end

  @impl true
  def handle_cast({:add, name, age, favorite_food}, characters) do
    new_character = %RelayServer.Character{name: name, age: age, favorite_food: favorite_food}
    characters = [new_character | characters]
    {:noreply, characters}
  end
end
