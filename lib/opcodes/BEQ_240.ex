defmodule Nex.Opcodes.O240 do
  @moduledoc """
  BEQ                    BEQ Branch on result zero                      BEQ
                                                        N Z C I D V
  Operation:  Branch on Z = 1                           _ _ _ _ _ _
                               (Ref: 4.1.1.5)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Relative      |   BEQ Oper            |    F0   |    2    |    2*    |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if branch occurs to same  page.
  * Add 2 if branch occurs to next  page.
  """

  @cycles 2
  def run(cpu) do
    Nex.Opcodes.ConditionalJump.relative(cpu, @cycles, cpu.registers.status.zero_result, 1, &format/1)
  end

  def format(ops) do
    "BEQ $#{String.upcase(Hexate.encode(ops))}"
  end
end