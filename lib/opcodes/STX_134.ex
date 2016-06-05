defmodule Nex.Opcodes.O134 do
  require Logger
  @moduledoc """

  STX                    STX Store index X in memory                    STX

  Operation: X -> M                                     N Z C I D V
                                                        _ _ _ _ _ _
                                 (Ref: 7.2)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Zero Page     |   STX Oper            |    86   |    2    |    3     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 3
  def run(cpu) do
    {cpu, [address]} = Nex.CPU.read_from_pc(cpu, 1)
    value = cpu.registers.x
    Logger.info "[Opcode]\t#{format(address)} (#{address})"
    {Nex.CPU.store(cpu, address, value), @cycles}
  end

  def format(ops) do
    "STX $#{String.upcase(Hexate.encode(ops))}"
  end
end