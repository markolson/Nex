defmodule Nex.Opcodes.O24 do
  @moduledoc """
  CLC                       CLC Clear carry flag                        CLC

  Operation:  0 -> C                                    N Z C I D V
                                                        _ _ 0 _ _ _
                                (Ref: 3.0.2)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   CLC                 |    18   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
     new_registers = cpu.registers.status
      |> Nex.CPU.StatusRegister.set_carry(false)

      op_log = %{bytes: [], log: "CLC"}

    {Nex.CPU.update_status_reg(cpu, new_registers), @cycles, op_log}
  end
end