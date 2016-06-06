defmodule Nex.Opcodes.O133 do
  @moduledoc """
  STA                  STA Store accumulator in memory                  STA

  Operation:  A -> M                                    N Z C I D V
                                                        _ _ _ _ _ _
                                (Ref: 2.1.2)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Zero Page     |   STA Oper            |    85   |    2    |    3     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 3
  def run(cpu) do
    {cpu, [address]} = Nex.CPU.read_from_pc(cpu, 1)
    value = cpu.registers.a

    old_value_for_logging = Hexate.encode(Nex.CPU.retrieve(cpu, address), 2)
    op_log = %{bytes: [address], log: format(address, old_value_for_logging)}
    {Nex.CPU.store(cpu, address, value), @cycles, op_log}
  end

  def format(address, old_value_for_logging) do
    "STA $#{String.upcase(Hexate.encode(address, 2))} = #{old_value_for_logging}"
  end
end