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
    raw_address = translate(address)
    mapped_address = if raw_address >= 0x8000, do: raw_address - 0x8000, else: raw_address
    Logger.debug "[Mapper0]\t#{words}@#{Hexate.encode(mapped_address, 4)}"
    Enum.slice(rom, mapped_address, words)
  end

  # Convert $C000-$FFFF -> $8000-$BFFF
  # TODO: _Don't_ convert NROM-256. How to tell? Header flag?
  def translate(address) when address >= 0xC000 do
    new_address = (address ^^^ 0b0100_0000_0000_0000) # subtract 4 to shift the mirroring to the 'real' loc
    Logger.debug "[Mapper0]\t#{Hexate.encode(address,4)}->#{Hexate.encode(new_address,4)}"
    new_address |> translate
  end

  # Transform back to an int and return if there's no other mapping special cases (above) to deal with
  def translate(address), do: address
end