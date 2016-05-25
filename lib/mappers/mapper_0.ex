defmodule Nex.Mappers.Mapper_0 do
  use Bitwise
  def read(rom, address) do
    IO.inspect "Reading #{address}" # TOOD output as hex :-\
  end

  def translate(address) when is_integer(address), do: translate(<<address::size(16)>>)

  # Convert $C000 -> $8000
  def translate(<<12::integer-size(4), rest::integer-size(12)>> = address) do
    # blargh, decoding and then re-coding. gotta be a better way.
    <<int_address::unsigned-big-integer-size(16)>> = address
    (int_address ^^^ 0b0100_0000_0000_0000) # subtract 4
    |> translate
  end

  def translate(address) do
    <<int_address::unsigned-big-integer-size(16)>> = address
    int_address
  end
end