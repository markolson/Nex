# http://wiki.nesdev.com/w/index.php/NROM
# http://wiki.nesdev.com/w/index.php/CPU_memory_map
# requests will come from the CPU to the mapper, mapper will need 
#  to convert 8000 -> internal offset, starting at 0000 of data

# All Banks are fixed,
# CPU $6000-$7FFF: Family Basic only: PRG RAM, mirrored as necessary to fill entire 8 KiB window, write protectable with an external switch
# CPU $8000-$BFFF: First 16 KB of ROM.
# CPU $C000-$FFFF: Last 16 KB of ROM (NROM-256) or mirror of $8000-$BFFF (NROM-128).

defmodule Nex.Mappers.Mapper_0 do
  use Bitwise
  require Logger
  def read(rom, address, words \\ 1) do
    # TODO: CPU will say ... what? Does this need the 8000 offset?
    # The 0x8000 is only for the ROM... Hm.
    mapped_address = translate(address) - 0x8000 
    Logger.debug "[Mapper0]\t[Reading #{words}]\t#{mapped_address} | #{Hexate.encode(mapped_address, 4)}"
    Enum.slice(rom, mapped_address, words)
  end

  def translate(address) when is_integer(address), do: translate(<<address::size(16)>>)

  # Convert $C000-$FFFF -> $8000-$BFFF
  # TODO: _Don't_ convert NROM-256. How to tell? Header flag?
  def translate(<<x::integer-size(4), rest::integer-size(12)>> = address) when x >= 0xC do
    # blargh, decoding and then re-coding. gotta be a better way.
    <<int_address::unsigned-big-integer-size(16)>> = address
    new_address = (int_address ^^^ 0b0100_0000_0000_0000) # subtract 4 to shift the mirroring to the 'real' loc
    Logger.debug "[Mapper0]\t[Translate]\t#{Hexate.encode(int_address,4)}->#{Hexate.encode(new_address,4)}"
    new_address |> translate
  end

  # Transform back to an int and return if there's no other mapping special cases (above) to deal with
  def translate(address) do
    <<int_address::unsigned-big-integer-size(16)>> = address
    int_address
  end
end