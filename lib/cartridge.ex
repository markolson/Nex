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

  def parse(<<"NES", 26, data::binary>>) do
    {header, rest} = split_header(data)
    %Nex.Cartridge{data: rest, header: header}
  end

  def parse(_) do
    {:error, :invalid_nes_file}
  end

  # http://wiki.nesdev.com/w/index.php/INES
  defp split_header(data) do
    <<
      prg_rom_16k_chunks::size(8),  # really byte 4
      chr_rom_8k_chunks::size(8),   # byte 5
      # flags6 
      flag_6::size(8),                   # byte 6
      flat_7::size(8),                   # byte 7
      prg_ram_8k_chunks::size(8),   # byte 8, 0 is 1 for compat
      flat_9::size(8),                   # byte 9
      flat_10::size(8),
      0::size(40),
      rest::binary
    >> = data
    {
      %{
        prg_rom_16k_chunks: prg_rom_16k_chunks,
        chr_rom_8k_chunks: chr_rom_8k_chunks,
        prg_ram_8k_chunks: prg_ram_8k_chunks
      },
      rest
    }
  end
end