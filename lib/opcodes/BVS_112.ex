defmodule Nex.Opcodes.O112 do
  @moduledoc """
  BVS                    BVS Branch on overflow set                     BVS

  Operation:  Branch on V = 1                           N Z C I D V
                                                        _ _ _ _ _ _
                               (Ref: 4.1.1.7)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Relative      |   BVS Oper            |    70   |    2    |    2*    |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if branch occurs to same page.
  * Add 2 if branch occurs to different page.
  """

  @cycles 2
  def run(cpu) do
    Nex.Opcodes.ConditionalJump.relative(cpu, @cycles, cpu.registers.status.overflow_flag, 1, &format/1)
  end

  def format(ops) do
    "BVS $#{String.upcase(Hexate.encode(ops))}"
  end
end