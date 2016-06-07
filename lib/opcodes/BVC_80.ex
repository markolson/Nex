defmodule Nex.Opcodes.O80 do
  @moduledoc """
  BVC                   BVC Branch on overflow clear                    BVC

  Operation:  Branch on V = 0                           N Z C I D V
                                                        _ _ _ _ _ _
                               (Ref: 4.1.1.8)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Relative      |   BVC Oper            |    50   |    2    |    2*    |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if branch occurs to same page.
  * Add 2 if branch occurs to different page.
  """

  @cycles 2
  def run(cpu) do
    Nex.Opcodes.ConditionalJump.relative(cpu, @cycles, cpu.registers.status.overflow_flag, 0, &format/1)
  end

  def format(ops) do
    "BVC $#{String.upcase(Hexate.encode(ops))}"
  end
end