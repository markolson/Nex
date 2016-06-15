defmodule Nex.Opcodes.O196 do
  @moduledoc """
  CPY                  CPY Compare memory and index Y                   CPY
                                                        N Z C I D V
  Operation:  Y - M                                     / / / _ _ _
                                 (Ref: 7.9)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Zero Page     |   CPY Oper            |    C4   |    2    |    3     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    {cpu, [address]} = Nex.CPU.read_from_pc(cpu, 1)
    value = Nex.CPU.retrieve(cpu, address)
    result = cpu.registers.y - value

    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(result)
      |> StatusRegister.set_zero(result)
      |> StatusRegister.set_carry(result >= 0)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)

    op_log = %{bytes: [address], log: format(address, value)}
    {cpu, @cycles, op_log}
  end

  def format(address, old_value_for_logging) do
    "CPY $#{String.upcase(Hexate.encode(address, 2))} = #{Hexate.encode(old_value_for_logging,2)}"
  end
end