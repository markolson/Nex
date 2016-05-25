# CPU $6000-$7FFF: Family Basic only: PRG RAM, mirrored as necessary to fill entire 8 KiB window, write protectable with an external switch
# CPU $8000-$BFFF: First 16 KB of ROM.
# CPU $C000-$FFFF: Last 16 KB of ROM (NROM-256) or mirror of $8000-$BFFF (NROM-128).

defmodule Nex.Mappers.Mapper_0Test do
  use ExUnit.Case

  alias Nex.Mappers.Mapper_0, as: M

  @rom [0x4C, 0xF5, 0xC5]

  # $8000-$BFFF mirrors $C000-$FFFF and vice-versa
  test "translates C000 -> 8000" do
    assert 0x8000 = M.translate(0xC000)
  end

  test "leaves 8000 -> 8000 alone" do
    assert 0x8000 = M.translate(0x8000)
  end

  test "leaves all other bits alone" do
    assert 0x915F = M.translate(0xD15F)
    assert 0xBFFF = M.translate(0xFFFF)
  end

  test "reads the first opcode" do
    assert [0x4c] = M.read(@rom, 0x8000)
    assert [0x4c] = M.read(@rom, 0xC000)
  end
end