defmodule Nex.Opcodes.O138 do
  @moduledoc """
  TXA                TXA Transfer index X to accumulator                TXA
                                                        N Z C I D V
  Operation:  X -> A                                    / / _ _ _ _
                                 (Ref: 7.12)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   TXA                 |    8A   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    Nex.Opcodes.Transfer.move(cpu, :x, :a, "TXA")
  end
end