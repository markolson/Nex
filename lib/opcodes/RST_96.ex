defmodule Nex.Opcodes.O96 do
  @moduledoc """
  RTS                    RTS Return from subroutine                     RTS
                                                        N Z C I D V
  Operation:  PC fromS, PC + 1 -> PC                    _ _ _ _ _ _
                                 (Ref: 8.2)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   RTS                 |    60   |    1    |    6     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 6
  def run(cpu) do
    use Bitwise
    {cpu, [high,low]} = Nex.CPU.pop_stack_values(cpu, 2)
    address = ((high <<< 8) + low) + 1

    op_log = %{bytes: [], log: format(address)}
    {Nex.CPU.update_pc(cpu, address), @cycles, op_log}
  end

  def format(ops) do
    "RTS"
  end
end