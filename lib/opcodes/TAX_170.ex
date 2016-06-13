defmodule Nex.Opcodes.O170 do
  @moduledoc """
  TAX                TAX Transfer accumulator to index X                TAX

  Operation:  A -> X                                    N Z C I D V
                                                        / / _ _ _ _
                                 (Ref: 7.11)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   TAX                 |    AA   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    Nex.Opcodes.Transfer.move(cpu, :a, :x, "TAX")
  end
end