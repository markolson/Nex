defmodule Nex.Opcodes.O48 do
  @moduledoc """
  BMI                    BMI Branch on result minus                     BMI

  Operation:  Branch on N = 1                           N Z C I D V
                                                        _ _ _ _ _ _
                               (Ref: 4.1.1.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Relative      |   BMI Oper            |    30   |    2    |    2*    |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if branch occurs to same page.
  * Add 1 if branch occurs to different page.
  """

  @cycles 2
  def run(cpu) do
    Nex.Opcodes.ConditionalJump.relative(cpu, @cycles, cpu.registers.status.sign_flag, 1, &format/1)
  end

  def format(ops) do
    "BMI $#{String.upcase(Hexate.encode(ops))}"
  end
end