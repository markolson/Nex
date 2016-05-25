defmodule Nex.Cartridge do
  @moduledoc """
  INES ROM parser
  """

  defstruct raw_data: nil, 
            header: nil,
            program: nil,
            mapper: nil


  def load(cartridge_path) do
    case File.read(cartridge_path) do
      {:ok, data} -> parse(data)
      {:error, failure_type} -> {:error, "Womp Womp"}
    end
  end

  def parse(<<"NES", 26, header::binary-size(12), rest::binary>>) do
    header = split_header(header)



    prg_rom_size = header.prg_rom_16k_chunks * 16384 # 16k
    prg_rom = extract_program_rom(header, rest)

    <<mapper_id>> = <<header.flag_7.mapper_upper_nybble::size(4),header.flag_6.mapper_lower_nybble::size(4)>>
    mapper = Nex.Mappers.get(mapper_id)

    %Nex.Cartridge{raw_data: rest, header: header, program: prg_rom, mapper: mapper}
  end

  def parse(_) do
    {:error, :invalid_nes_file}
  end

  defp extract_program_rom(header = %{flag_6: %{trainer_present: true}}, data) do
    :binary.bin_to_list(data, 512, header.prg_rom_16k_chunks * 16384)
  end

  defp extract_program_rom(header = %{flag_6: %{trainer_present: false}}, data) do
    :binary.bin_to_list(data, 0, header.prg_rom_16k_chunks * 16384)
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
      flag_6: Nex.Cartridge.INES.Flags6.parse(flag_6),
      flag_7: Nex.Cartridge.INES.Flags7.parse(flag_7)
    }
  end
end

defmodule Nex.Cartridge.INES.Flags6 do
  defstruct veritcal_mirroring:     false,
            horizontal_mirroring:   false,
            four_screen_vram:       false,
            persistant_storage:     false,
            trainer_present:        false,
            mapper_lower_nybble:    0

  def parse(byte) do
    use Bitwise

    %Nex.Cartridge.INES.Flags6{
      mapper_lower_nybble:        byte &&& 0b0000_1111,
      trainer_present:      1 == (byte &&& 0b0010_0000),
      persistant_storage:   1 == (byte &&& 0b0100_0000)
    }
  end
end

defmodule Nex.Cartridge.INES.Flags7 do
  defstruct vs_unisystem:         false,
            playchoice_10:        false,
            ines_2_format:        false,
            mapper_upper_nybble:  0

  def parse(byte) do
    use Bitwise

    %Nex.Cartridge.INES.Flags7{
      mapper_upper_nybble:      byte &&& 0b0000_1111
    }
  end
end
