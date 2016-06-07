defmodule Nex.Opcodes.O248 do
  @moduledoc """
  SED                       SED Set decimal mode                        SED
                                                        N Z C I D V
  Operation:  1 -> D                                    _ _ _ _ 1 _
                                (Ref: 3.3.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   SED                 |    F8   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
     new_registers = cpu.registers.status
      |> Nex.CPU.StatusRegister.set_decimal_mode(true)

    op_log = %{bytes: [], log: "SED"}
    {Nex.CPU.update_status_reg(cpu, new_registers), @cycles, op_log}
  end
end