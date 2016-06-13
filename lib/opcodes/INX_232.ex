defmodule Nex.Opcodes.O232 do
  @moduledoc """
  INX                    INX Increment Index X by one                   INX
                                                        N Z C I D V
  Operation:  X + 1 -> X                                / / _ _ _ _
                                 (Ref: 7.4)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   INX                 |    E8   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    op_log = %{bytes: [], log: "INX"}
    <<end_value::size(8),_::binary>> = <<cpu.registers.x + 1>>
    new_registers = cpu.registers.status 
      |> StatusRegister.set_zero(end_value) 
      |> StatusRegister.set_negative(end_value)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)
    {Nex.CPU.update_reg(cpu, :x, end_value), @cycles, op_log}
  end
end