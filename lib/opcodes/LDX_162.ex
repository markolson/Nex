defmodule Nex.Opcodes.O162 do
  @moduledoc """

  LDX                   LDX Load index X with memory                    LDX

  Operation:  M -> X                                    N Z C I D V
                                                        / / _ _ _ _
                                 (Ref: 7.0)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Immediate     |   LDX #Oper           |    A2   |    2    |    2     |
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
    {Nex.CPU.update_reg(cpu, :x, value), @cycles, op_log}
  end

  def format(ops) do
    "LDX #$#{String.upcase(Hexate.encode(ops, 2))}"
  end
end