defmodule Nex.Opcodes.O104 do
  @moduledoc """
  PLA                 PLA Pull accumulator from stack                   PLA

  Operation:  A fromS                                   N Z C I D V
                                                        _ _ _ _ _ _
                                 (Ref: 8.6)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   PLA                 |    68   |    1    |    4     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 4
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    {cpu, value} = Nex.CPU.pop_stack_value(cpu)
    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(value)
      |> StatusRegister.set_zero(value)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)
    op_log = %{bytes: [], log: "PLA"}
    {Nex.CPU.update_reg(cpu, :a, value), @cycles, op_log}
  end
end