defmodule Nex.Opcodes.O8 do
  @moduledoc """
  PHP                 PHP Push processor status on stack                PHP

  Operation:  P toS                                     N Z C I D V
                                                        _ _ _ _ _ _
                                 (Ref: 8.11)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   PHP                 |    08   |    1    |    3     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 3
  def run(cpu) do
    use Bitwise
    byte = Nex.CPU.StatusRegister.to_byte(cpu.registers.status)
    # TODO: WHY DO I HAVE TO SET THIS BIT. suuuuuper worrying why 6F changes to 7F on the PLA
    # C7E8  68        PLA                             A:00 X:00 Y:00 P:6F SP:FA CYC:202
    # C7E9  29 EF     AND #$EF                        A:7F X:00 Y:00 P:6D SP:FB CYC:214
    # TODO: Is this from the PHP or the PLA
    byte = 0b0001_0000 ||| byte
    cpu = Nex.CPU.push_stack_value(cpu, byte)

    op_log = %{bytes: [], log: "PHP"}
    {cpu, @cycles, op_log}
  end
end