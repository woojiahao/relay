defmodule RelayServer.Client do
  @moduledoc """
  Client for the relay server
  """

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :worker
    }
  end

  def start_link() do
    IO.puts("Starting client...")
    {:ok, self()}
  end

  def add(name, age, favorite_food) do
    GenServer.cast(Server, {:add, name, age, favorite_food})
  end

  def delete(name) do
    GenServer.cast(Server, {:delete, name})
  end

  def get_all() do
    GenServer.call(Server, :get_all)
  end

  def get(name) do
    GenServer.call(Server, {:get, name})
  end
end
