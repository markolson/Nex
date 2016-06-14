defmodule Nex.Opcodes.O42 do
  @moduledoc """
  ROL          ROL Rotate one bit left (memory or accumulator)          ROL

               +------------------------------+
               |         M or A               |
               |   +-+-+-+-+-+-+-+-+    +-+   |
  Operation:   +-< |7|6|5|4|3|2|1|0| <- |C| <-+         N Z C I D V
                   +-+-+-+-+-+-+-+-+    +-+             / / / _ _ _
                                 (Ref: 10.3)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Accumulator   |   ROL A               |    2A   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    use Bitwise
    value = (cpu.registers.a <<< 1) ^^^ cpu.registers.status.carry_flag
    
    new_registers = cpu.registers.status |> StatusRegister.set_carry(value > 0xFF)

    <<value::size(8),_::binary>> = <<value>>

    new_registers = new_registers |> StatusRegister.set_negative(value) |> StatusRegister.set_zero(value)
      
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)

    
    op_log = %{bytes: [value], log: "ROL A"}
    {Nex.CPU.update_reg(cpu, :a, value), @cycles, op_log}
  end
end