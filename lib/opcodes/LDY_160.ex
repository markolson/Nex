defmodule Nex.Opcodes.O160 do
  @moduledoc """
  LDY                   LDY Load index Y with memory                    LDY
                                                        N Z C I D V
  Operation:  M -> Y                                    / / _ _ _ _
                                 (Ref: 7.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Immediate     |   LDY #Oper           |    A0   |    2    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    {cpu, [value]} = Nex.CPU.read_from_pc(cpu, 1)
    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(value)
      |> StatusRegister.set_zero(value)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)

    op_log = %{bytes: [value], log: format(value)}
    {Nex.CPU.update_reg(cpu, :y, value), @cycles, op_log}
  end

  def format(ops) do
    "LDY #$#{String.upcase(Hexate.encode(ops, 2))}"
  end
end