defmodule Nex.Opcodes.O142 do
  @moduledoc """

  STX                    STX Store index X in memory                    STX

  Operation: X -> M                                     N Z C I D V
                                                        _ _ _ _ _ _
                                 (Ref: 7.2)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Absolute      |   STX Oper            |    8E   |    3    |    4     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 3
  def run(cpu) do
    use Bitwise
    {cpu, [low, high]} = Nex.CPU.read_from_pc(cpu, 2)
    address = (high <<< 8) ||| low
    value = cpu.registers.x
    existing_value = Nex.CPU.retrieve(cpu, address)

    op_log = %{bytes: [address], log: format(address, existing_value)}
    {Nex.CPU.store(cpu, address, value), @cycles, op_log}
  end

  def format(address, value) do
    "STX $#{String.upcase(Hexate.encode(address, 4))} = #{String.upcase(Hexate.encode(value, 2))}"
  end
end