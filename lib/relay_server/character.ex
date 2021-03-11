defmodule RelayServer.Character do
  defstruct [:name, :age, :favorite_food]

  @type t :: %RelayServer.Character{name: String.t(), age: integer, favorite_food: String.t()}
end
