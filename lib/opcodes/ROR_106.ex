defmodule Nex.Opcodes.O106 do
  @moduledoc """
  ROR          ROR Rotate one bit right (memory or accumulator)         ROR

               +------------------------------+
               |                              |
               |   +-+    +-+-+-+-+-+-+-+-+   |
  Operation:   +-> |C| -> |7|6|5|4|3|2|1|0| >-+         N Z C I D V
                   +-+    +-+-+-+-+-+-+-+-+             / / / _ _ _
                                 (Ref: 10.4)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Accumulator   |   ROR A               |    6A   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    use Bitwise
    value = (cpu.registers.a ^^^ (cpu.registers.status.carry_flag <<< 8) >>> 1)

    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(value)
      |> StatusRegister.set_zero(value)
      |> StatusRegister.set_carry((cpu.registers.a &&& 0b0000_0001) == 1)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)

    op_log = %{bytes: [value], log: "ROR A"}
    {Nex.CPU.update_reg(cpu, :a, value), @cycles, op_log}
  end
end