defmodule Nex.Mappers do
  @mappers %{
    "0": Nex.Mappers.Mapper_0
  }

  def get(id) when is_binary(id) do
    Dict.get(@mappers, String.to_atom(id))
  end

  def get(id), do: get(to_string(id))
end

defprotocol Nex.Mapper do
  def read(rom, address)
end