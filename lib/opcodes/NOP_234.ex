defmodule Nex.Opcodes.O234 do
  @moduledoc """

  NOP                         NOP No operation                          NOP
                                                        N Z C I D V
  Operation:  No Operation (2 cycles)                   _ _ _ _ _ _

  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   NOP                 |    EA   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    op_log = %{bytes: [], log: "NOP"}
    {cpu, @cycles, op_log}
  end

  def format(ops \\ []) do
    "NOP"
  end
end