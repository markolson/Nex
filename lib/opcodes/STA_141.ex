defmodule Nex.Opcodes.O141 do
  @moduledoc """
  STA                  STA Store accumulator in memory                  STA

  Operation:  A -> M                                    N Z C I D V
                                                        _ _ _ _ _ _
                                (Ref: 2.1.2)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Absolute      |   STA Oper            |    8D   |    3    |    4     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 4
  def run(cpu) do
    use Bitwise
    {cpu, [low, high]} = Nex.CPU.read_from_pc(cpu, 2)
    address = (high <<< 8) ||| low
    value = cpu.registers.a

    old_value_for_logging = Hexate.encode(Nex.CPU.retrieve(cpu, address), 2)
    op_log = %{bytes: [address], log: format(address, old_value_for_logging)}
    {Nex.CPU.store(cpu, address, value), @cycles, op_log}
  end

  def format(address, old_value_for_logging) do
    "STA $#{String.upcase(Hexate.encode(address, 4))} = #{old_value_for_logging}"
  end
end