defmodule Nex.Opcodes.O228 do
  @moduledoc """
  CPX                  CPX Compare memory and index X                   CPX
                                                        N Z C I D V
  Operation:  Y - M                                     / / / _ _ _
                                 (Ref: 7.9)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Zero Page     |   CPX Oper            |    E4   |    2    |    3     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 3
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    {cpu, [address]} = Nex.CPU.read_from_pc(cpu, 1)
    value = Nex.CPU.retrieve(cpu, address)
    result = cpu.registers.x - value

    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(result)
      |> StatusRegister.set_zero(result)
      |> StatusRegister.set_carry(result >= 0)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)

    op_log = %{bytes: [address], log: format(address, value)}
    {cpu, @cycles, op_log}
  end

  def format(address, old_value_for_logging) do
    "CPX $#{String.upcase(Hexate.encode(address, 2))} = #{Hexate.encode(old_value_for_logging,2)}"
  end
end