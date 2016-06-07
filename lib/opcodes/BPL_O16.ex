defmodule Nex.Opcodes.O16 do
  @moduledoc """
  BPL                     BPL Branch on result plus                     BPL

  Operation:  Branch on N = 0                           N Z C I D V
                                                        _ _ _ _ _ _
                               (Ref: 4.1.1.2)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Relative      |   BPL Oper            |    10   |    2    |    2*    |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if branch occurs to same page.
  * Add 2 if branch occurs to different page.
  """

  @cycles 2
  def run(cpu) do
    Nex.Opcodes.ConditionalJump.relative(cpu, @cycles, cpu.registers.status.sign_flag, 0, &format/1)
  end

  def format(ops) do
    "BPL $#{String.upcase(Hexate.encode(ops))}"
  end
end