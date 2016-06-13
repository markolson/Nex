defmodule Nex.Opcodes.O136 do
  @moduledoc """
  DEY                   DEY Decrement index Y by one                    DEY

  Operation:  X - 1 -> Y                                N Z C I D V
                                                        / / _ _ _ _
                                 (Ref: 7.7)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   DEY                 |    88   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    op_log = %{bytes: [], log: "DEY"}
    <<end_value::size(8),_::binary>> = <<cpu.registers.y - 1>>
    new_registers = cpu.registers.status 
      |> StatusRegister.set_zero(end_value) 
      |> StatusRegister.set_negative(end_value)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)
    {Nex.CPU.update_reg(cpu, :y, end_value), @cycles, op_log}
  end
end