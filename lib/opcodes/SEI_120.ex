defmodule Nex.Opcodes.O120 do
  @moduledoc """
  SEI                 SEI Set interrupt disable status                  SED
                                                        N Z C I D V
  Operation:  1 -> I                                    _ _ _ 1 _ _
                                (Ref: 3.2.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   SEI                 |    78   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
     new_registers = cpu.registers.status
      |> Nex.CPU.StatusRegister.set_interrupt_disabled(true)

    op_log = %{bytes: [], log: "SEI"}
    {Nex.CPU.update_status_reg(cpu, new_registers), @cycles, op_log}
  end
end