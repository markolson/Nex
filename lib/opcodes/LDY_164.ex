defmodule Nex.Opcodes.O164 do
  @moduledoc """
  LDY                   LDY Load index Y with memory                    LDY
                                                        N Z C I D V
  Operation:  M -> Y                                    / / _ _ _ _
                                 (Ref: 7.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Zero Page     |   LDY Oper            |    A4   |    2    |    3     |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 when page boundary is crossed.
  """

  @cycles 3
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    {cpu, [address]} = Nex.CPU.read_from_pc(cpu, 1)
    value = Nex.CPU.retrieve(cpu, address)

    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(value)
      |> StatusRegister.set_zero(value)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)

    op_log = %{bytes: [address], log: format(address, value)}
    {Nex.CPU.update_reg(cpu, :y, value), @cycles, op_log}
  end

  def format(address, value) do
    "LDY $#{String.upcase(Hexate.encode(address, 4))} = #{String.upcase(Hexate.encode(value, 2))}"
  end
end