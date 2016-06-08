defmodule Nex.Opcodes.O72 do
  @moduledoc """
  PHA                   PHA Push accumulator on stack                   PHA

  Operation:  A toS                                     N Z C I D V
                                                        _ _ _ _ _ _
                                 (Ref: 8.5)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   PHA                 |    48   |    1    |    3     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 3
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    cpu = Nex.CPU.push_stack_value(cpu, cpu.registers.a)
    op_log = %{bytes: [], log: "PHA"}
    {cpu, @cycles, op_log}
  end
end