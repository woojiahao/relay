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

  @spec add(String.t(), integer(), String.t()) :: :ok | {:error, any}
  def add(name, age, favorite_food) do
    payload =
      Jason.encode!(%{
        "name" => name,
        "age" => age,
        "favorite_food" => favorite_food
      })

    RelayServer.Producer.publish(:ADD, payload)
  end

  @spec delete(String.t()) :: :ok | {:error, any}
  def delete(name) do
    payload =
      Jason.encode!(%{
        "name" => name
      })

    RelayServer.Producer.publish(:DELETE, payload)
  end

  @spec get_all() :: :ok | {:error, any}
  def get_all() do
    payload = Jason.encode!(%{})
    RelayServer.Producer.publish(:GETA, payload)
  end

  @spec get(String.t()) :: :ok | {:error, any}
  def get(name) do
    payload =
      Jason.encode!(%{
        "name" => name
      })

    RelayServer.Producer.publish(:GET, payload)
  end
end
