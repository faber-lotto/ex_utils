defmodule ExUtils do

  def struct_to_json(param) do
    Map.drop(param, [:__struct__])
    |> Poison.encode!
  end
end
