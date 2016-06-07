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
    byte = Nex.CPU.StatusRegister.to_hex(cpu.registers.status)
    cpu = Nex.CPU.push_stack_value(cpu, byte)

    op_log = %{bytes: [], log: "PHP"}
    {cpu, @cycles, op_log}
  end
end