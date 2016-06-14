defmodule Nex.Opcodes.O132 do
  @moduledoc """
  STY                    STY Store index Y in memory                    STY

  Operation: Y -> M                                     N Z C I D V
                                                        _ _ _ _ _ _
                                 (Ref: 7.3)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Zero Page     |   STY Oper            |    84   |    2    |    3     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 3
  def run(cpu) do
    {cpu, [address]} = Nex.CPU.read_from_pc(cpu, 1)
    value = cpu.registers.y

    op_log = %{bytes: [address], log: format(address)}
    {Nex.CPU.store(cpu, address, value), @cycles, op_log}
  end

  def format(ops) do
    "STY $#{String.upcase(Hexate.encode(ops, 2))}"
  end
end