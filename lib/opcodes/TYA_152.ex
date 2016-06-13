defmodule Nex.Opcodes.O152 do
  @moduledoc """
  TYA                TYA Transfer index Y to accumulator                TYA

  Operation:  Y -> A                                    N Z C I D V
                                                        / / _ _ _ _
                                 (Ref: 7.14)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   TYA                 |    98   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    Nex.Opcodes.Transfer.move(cpu, :y, :a, "TYA")
  end
end