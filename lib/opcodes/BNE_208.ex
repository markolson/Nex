defmodule Nex.Opcodes.O208 do
  @moduledoc """
  BNE                   BNE Branch on result not zero                   BNE

  Operation:  Branch on Z = 0                           N Z C I D V
                                                        _ _ _ _ _ _
                               (Ref: 4.1.1.6)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Relative      |   BMI Oper            |    D0   |    2    |    2*    |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if branch occurs to same page.
  * Add 2 if branch occurs to different page.
  """

  @cycles 2
  def run(cpu) do
    Nex.Opcodes.ConditionalJump.relative(cpu, @cycles, cpu.registers.status.zero_result, 0, &format/1)
  end

  def format(ops) do
    "BNE $#{String.upcase(Hexate.encode(ops))}"
  end
end