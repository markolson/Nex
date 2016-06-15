defmodule Nex.Opcodes.O197 do
  @moduledoc """
  CMP                CMP Compare memory and accumulator                 CMP

  Operation:  A - M                                     N Z C I D V
                                                        / / / _ _ _
                                (Ref: 4.2.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Zero Page     |   CMP Oper            |    C5   |    2    |    3     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 3
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    {cpu, [address]} = Nex.CPU.read_from_pc(cpu, 1)
    value = Nex.CPU.retrieve(cpu, address)

    result = cpu.registers.a - value
    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(result)
      |> StatusRegister.set_zero(result)
      |> StatusRegister.set_carry(result >= 0)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)

    op_log = %{bytes: [address], log: format(address, value)}
    {cpu, @cycles, op_log}
  end

  def format(address, old_value_for_logging) do
    "ADC $#{String.upcase(Hexate.encode(address, 2))} = #{Hexate.encode(old_value_for_logging,2)}"
  end
end