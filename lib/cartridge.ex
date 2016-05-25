defmodule Nex.Cartridge do
  @moduledoc """
  INES ROM parser
  """

  defstruct data: nil, header: nil

  def load(cartridge_path) do
    case File.read(cartridge_path) do
      {:ok, data} -> parse(data)
      {:error, failure_type} -> {:error, "Womp Womp"}
    end
  end

  def parse(<<"NES", 26, header::binary-size(12), rest::binary>>) do
    header = split_header(header)
    IO.inspect header

    %Nex.Cartridge{data: rest, header: header}
  end

  def parse(_) do
    {:error, :invalid_nes_file}
  end

  # http://wiki.nesdev.com/w/index.php/INES
  defp split_header(<<
      prg_rom_16k_chunks::unsigned-integer,
      chr_rom_8k_chunks::unsigned-integer,
      flag_6::size(8), 
      flag_7::size(8),
      prg_ram_8k_chunks::unsigned-integer,
      flag_9::size(8),
      flag_10::size(8),
      0::size(40)
    >>) do

    %{
      prg_rom_16k_chunks: prg_rom_16k_chunks,
      chr_rom_8k_chunks: chr_rom_8k_chunks,
      prg_ram_8k_chunks: prg_ram_8k_chunks,
      flag_6: Nex.Cartridge.INES.Flags6.parse(flag_6)
    }
  end
end

defmodule Nex.Cartridge.INES.Flags6 do
  defstruct veritcal_mirroring:     false,
            horizontal_mirroring:   false,
            four_screen_vram:       false,
            persistant_storage:     false,
            trainer_exists:         false,
            lower_mapper_nybble:    false

  def parse(byte) do
    use Bitwise

    %Nex.Cartridge.INES.Flags6{
      lower_mapper_nybble: byte &&& 0b0000_1111,
      trainer_exists: 1 == (byte &&& 0b0010_0000),
      persistant_storage: 1 == (byte &&& 0b0100_0000)
    }
  end
end