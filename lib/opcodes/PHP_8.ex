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
    # In the byte pushed, bit 5 is always set to 1, and bit 4 is 1 if from an instruction (PHP or BRK)
    byte = 0b0011_0000 ||| byte
    cpu = Nex.CPU.push_stack_value(cpu, byte)

    op_log = %{bytes: [], log: "PHP"}
    {cpu, @cycles, op_log}
  end
end