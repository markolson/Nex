defmodule Nex.Opcodes.O200 do
  @moduledoc """
  INY                    INY Increment Index Y by one                   INY

  Operation:  Y + 1 -> Y                                N Z C I D V
                                                        / / _ _ _ _
                                 (Ref: 7.5)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   INY                 |    C8   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 3
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    op_log = %{bytes: [], log: "INY"}
    <<end_value::size(8),_::binary>> = <<cpu.registers.y + 1>>
    new_registers = cpu.registers.status 
      |> StatusRegister.set_zero(end_value) 
      |> StatusRegister.set_negative(end_value)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)
    {Nex.CPU.update_reg(cpu, :y, end_value), @cycles, op_log}
  end
end