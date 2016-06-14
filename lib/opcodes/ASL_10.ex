defmodule Nex.Opcodes.O10 do
  @moduledoc """
  ASL          ASL Shift Left One Bit (Memory or Accumulator)           ASL
                   +-+-+-+-+-+-+-+-+
  Operation:  C <- |7|6|5|4|3|2|1|0| <- 0
                   +-+-+-+-+-+-+-+-+                    N Z C I D V
                                                        / / / _ _ _
                                 (Ref: 10.2)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Accumulator   |   ASL A               |    0A   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    use Bitwise
    value = (cpu.registers.a <<< 1)
    <<value::size(8),_::binary>> = <<value>>

    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(value)
      |> StatusRegister.set_zero(value)
      |> StatusRegister.set_carry((cpu.registers.a &&& 0b1000_0000) == 128)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)


    op_log = %{bytes: [value], log: "ASL A"}
    {Nex.CPU.update_reg(cpu, :a, value), @cycles, op_log}
  end
end