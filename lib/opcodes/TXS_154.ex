defmodule Nex.Opcodes.O154 do
  @moduledoc """
  TXS              TXS Transfer index X to stack pointer                TXS
                                                        N Z C I D V
  Operation:  X -> S                                    _ _ _ _ _ _
                                 (Ref: 8.8)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   TXS                 |    9A   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    op_log = %{bytes: [], log: "TXS"}
    {Nex.CPU.update_reg(cpu, :stack_pointer, cpu.registers.x), @cycles, op_log}
  end
end