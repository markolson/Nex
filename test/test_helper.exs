ExUnit.start()

defmodule Nex.Test do
  def burn(bytes) do
    mapper = Nex.Mappers.get(0)
    cart = %Nex.Cartridge{header: %{}, program: bytes, mapper: mapper}
    cpu =  %Nex.CPU{cartridge: cart}
  end
end