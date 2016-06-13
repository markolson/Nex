defmodule Nex.Opcodes.O186 do
  @moduledoc """
  TSX              TSX Transfer stack pointer to index X                TSX

  Operation:  S -> X                                    N Z C I D V
                                                        / / _ _ _ _
                                 (Ref: 8.9)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   TSX                 |    BA   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    Nex.Opcodes.Transfer.move(cpu, :stack_pointer, :x, "TSX")
  end
end