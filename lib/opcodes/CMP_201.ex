defmodule Nex.Opcodes.O201 do
  @moduledoc """
  CMP                CMP Compare memory and accumulator                 CMP

  Operation:  A - M                                     N Z C I D V
                                                        / / / _ _ _
                                (Ref: 4.2.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Immediate     |   CMP #Oper           |    C9   |    2    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    {cpu, [value]} = Nex.CPU.read_from_pc(cpu, 1)
    result = cpu.registers.a - value
    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(result)
      |> StatusRegister.set_zero(result)
      |> StatusRegister.set_carry(result < 0x100)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)

    op_log = %{bytes: [value], log: format(value)}
    {cpu, @cycles, op_log}
  end

  def format(ops) do
    "CMP #$#{String.upcase(Hexate.encode(ops, 2))}"
  end
end