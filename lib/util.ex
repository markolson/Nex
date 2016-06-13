defmodule Nex.Util do
  # log things in nestest.log format
  def log(cpu, op_log) do
    require Logger
    Logger.info(
      Nex.CPU.hpc(op_log.start_op)
      <> "  " <> bytes_to_hex(op_log.bytes)
      <> String.ljust(op_log.log, 32)
      <> "A:" <> byte_to_hex(cpu.registers.a) <> " "
      <> "X:" <> byte_to_hex(cpu.registers.x) <> " "
      <> "Y:" <> byte_to_hex(cpu.registers.y) <> " "
      <> "P:" <> Nex.CPU.StatusRegister.to_hex(cpu.registers.status) <> " "
      <> "SP:" <> byte_to_hex(cpu.registers.stack_pointer) <> " "
      <> "CYC:" <> byte_to_hex(0x00) <> " "
    )
  end

  defp bytes_to_hex(bytes), do: Enum.join(Enum.map(bytes, &Hexate.encode(&1, 2)), " ") |> String.upcase |> String.ljust(10)
  defp byte_to_hex(byte), do: Hexate.encode(byte, 2) |> String.upcase

  def relative_value(value) when is_integer(value), do: relative_value(<<value::integer>>)
  def relative_value(<<1::size(1), rest::size(7)>>), do: 0 - rest
  def relative_value(<<0::size(1), rest::size(7)>>), do: rest
end
