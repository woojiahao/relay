defmodule RelayServer.Character do
  defstruct [:name, :age, :favorite_food]

  @type t :: %RelayServer.Character{name: String.t(), age: integer, favorite_food: String.t()}

  defimpl String.Chars, for: RelayServer.Character do
    def to_string(character) do
      "Character \"#{character.name}\" is #{character.age} years old and likes #{
        character.favorite_food
      }"
    end
  end
end
