defmodule Nex.Opcodes.O216 do
  @moduledoc """
  CLD                      CLD Clear decimal mode                       CLD

  Operation:  0 -> D                                    N A C I D V
                                                        _ _ _ _ 0 _
                                (Ref: 3.3.2)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   CLD                 |    D8   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
     new_registers = cpu.registers.status
      |> Nex.CPU.StatusRegister.set_decimal_mode(false)

    op_log = %{bytes: [], log: "CLD"}
    {Nex.CPU.update_status_reg(cpu, new_registers), @cycles, op_log}
  end
end