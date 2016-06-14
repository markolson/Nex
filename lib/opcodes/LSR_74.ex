defmodule Nex.Opcodes.O74 do
  @moduledoc """
  LSR          LSR Shift right one bit (memory or accumulator)          LSR

                   +-+-+-+-+-+-+-+-+
  Operation:  0 -> |7|6|5|4|3|2|1|0| -> C               N Z C I D V
                   +-+-+-+-+-+-+-+-+                    0 / / _ _ _
                                 (Ref: 10.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Accumulator   |   LSR A               |    4A   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    use Bitwise
    value = (cpu.registers.a >>> 1)

    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(value)
      |> StatusRegister.set_zero(value)
      |> StatusRegister.set_carry((cpu.registers.a &&& 0b0000_0001) == 1)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)

    op_log = %{bytes: [value], log: "LSR A"}
    {Nex.CPU.update_reg(cpu, :a, value), @cycles, op_log}
  end
end