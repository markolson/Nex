defmodule Nex.Opcodes.O76 do
  require Logger
  @moduledoc """

  JMP                     JMP Jump to new location                      JMP

  Operation:  (PC + 1) -> PCL                           N Z C I D V
              (PC + 2) -> PCH   (Ref: 4.0.2)            _ _ _ _ _ _
                                (Ref: 9.8.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Absolute      |   JMP Oper            |    4C   |    3    |    3     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 3
  def run(cpu) do
    use Bitwise
    {cpu, [low, high]} = Nex.CPU.read_from_pc(cpu, 2)
    absolute_jmp_address = (high <<< 8) ||| low

    op_log = %{bytes: [low, high], log: format(absolute_jmp_address)}
    {Nex.CPU.update_pc(cpu, absolute_jmp_address), @cycles, op_log}
  end

  def format(ops) do
    "JMP $#{String.upcase(Hexate.encode(ops))}"
  end
end