defmodule Nex.Opcodes.O184 do
  @moduledoc """
  CLV                      CLV Clear overflow flag                      CLV

  Operation: 0 -> V                                     N Z C I D V
                                                        _ _ _ _ _ 0
                                (Ref: 3.6.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   CLV                 |    B8   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
     new_registers = cpu.registers.status
      |> Nex.CPU.StatusRegister.set_overflow(false)

      op_log = %{bytes: [], log: "CLV"}

    {Nex.CPU.update_status_reg(cpu, new_registers), @cycles, op_log}
  end
end