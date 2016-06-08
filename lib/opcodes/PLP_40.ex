defmodule Nex.Opcodes.O40 do
  @moduledoc """
  PLP               PLP Pull processor status from stack                PLA

  Operation:  P fromS                                   N Z C I D V
                                                         From Stack
                                 (Ref: 8.12)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   PLP                 |    28   |    1    |    4     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 4
  def run(cpu) do
    use Bitwise
    alias Nex.CPU.StatusRegister
    {cpu, byte} = Nex.CPU.pop_stack_value(cpu)
    new_registers = StatusRegister.from_byte(cpu.registers.status, byte)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)
    op_log = %{bytes: [], log: "PLP"}
    {cpu, @cycles, op_log}
  end
end