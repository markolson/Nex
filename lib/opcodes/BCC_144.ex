defmodule Nex.Opcodes.O144 do
  @moduledoc """
  BCC                     BCC Branch on Carry Clear                     BCC
                                                        N Z C I D V
  Operation:  Branch on C = 0                           _ _ _ _ _ _
                               (Ref: 4.1.1.3)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Relative      |   BCC Oper            |    90   |    2    |    2*    |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if branch occurs to same page.
  * Add 2 if branch occurs to different page.
  """

  @cycles 2
  def run(cpu) do
    Nex.Opcodes.ConditionalJump.relative(cpu, @cycles, cpu.registers.status.carry_flag, 0, &format/1)
  end

  def format(ops) do
    "BCC $#{String.upcase(Hexate.encode(ops))}"
  end
end