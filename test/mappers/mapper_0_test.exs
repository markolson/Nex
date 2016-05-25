# CPU $6000-$7FFF: Family Basic only: PRG RAM, mirrored as necessary to fill entire 8 KiB window, write protectable with an external switch
# CPU $8000-$BFFF: First 16 KB of ROM.
# CPU $C000-$FFFF: Last 16 KB of ROM (NROM-256) or mirror of $8000-$BFFF (NROM-128).

defmodule Nex.Mappers.Mapper_0Test do
  use ExUnit.Case

  alias Nex.Mappers.Mapper_0, as: M

  @rom <<76, 245, 197>>

  # $8000-$BFFF mirrors $C000-$FFFF and vice-versa
  test "translates C000 -> 0000" do
    assert 0x8000 = M.translate(0xC000)
  end
end