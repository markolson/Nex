defmodule Nex.Opcodes.O176 do
  @moduledoc """
  BCS                      BCS Branch on carry set                      BCS

  Operation:  Branch on C = 1                           N Z C I D V
                                                        _ _ _ _ _ _
                               (Ref: 4.1.1.4)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Relative      |   BCS Oper            |    B0   |    2    |    2*    |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if branch occurs to same  page.
  * Add 2 if branch occurs to next  page.
  """

  @cycles 2
  def run(cpu) do
    Nex.Opcodes.ConditionalJump.relative(cpu, @cycles, cpu.registers.status.carry_flag, 1, &format/1)
  end

  def format(ops) do
    "BCS $#{String.upcase(Hexate.encode(ops))}"
  end
end