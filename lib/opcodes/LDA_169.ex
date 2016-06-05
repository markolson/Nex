defmodule Nex.Opcodes.O169 do
  require Logger
  @moduledoc """
  LDA                  LDA Load accumulator with memory                 LDA

  Operation:  M -> A                                    N Z C I D V
                                                        / / _ _ _ _
                                (Ref: 2.1.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Immediate     |   LDA #Oper           |    A9   |    2    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if page boundary is crossed.
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
    {Nex.CPU.update_reg(cpu, :a, value), @cycles, op_log}
  end

  def format(ops) do
    "LDA #$#{String.upcase(Hexate.encode(ops, 2))}"
  end
end