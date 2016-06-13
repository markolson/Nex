defmodule Nex.Opcodes.O168 do
  @moduledoc """
  TAY                TAY Transfer accumulator to index Y                TAY

  Operation:  A -> Y                                    N Z C I D V
                                                        / / _ _ _ _
                                 (Ref: 7.13)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   TAY                 |    A8   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    Nex.Opcodes.Transfer.move(cpu, :a, :y, "TAY")
  end
end