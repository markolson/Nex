defmodule Nex.Opcodes.O56 do
  @moduledoc """
  SEC                        SEC Set carry flag                         SEC

  Operation:  1 -> C                                    N Z C I D V
                                                        _ _ 1 _ _ _
                                (Ref: 3.0.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   SEC                 |    38   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
     new_registers = cpu.registers.status
      |> Nex.CPU.StatusRegister.set_carry(true)

      op_log = %{bytes: [], log: "SEC"}

    {Nex.CPU.update_status_reg(cpu, new_registers), @cycles, op_log}
  end

  def format(ops \\ []) do
    "SEC"
  end
end