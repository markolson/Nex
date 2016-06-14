defmodule Nex.Opcodes.O64 do
  @moduledoc """
  RTI                    RTI Return from interrupt                      RTI
                                                        N Z C I D V
  Operation:  P fromS PC fromS                           From Stack
                                 (Ref: 9.6)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   RTI                 |    4D   |    1    |    6     |
  +----------------+-----------------------+---------+---------+----------+

    src = PULL();
    SET_SR(src);
    src = PULL();
    src |= (PULL() << 8); /* Load return address from stack. */
    PC = (src);
  """

  @cycles 6
  def run(cpu) do
    use Bitwise
    alias Nex.CPU.StatusRegister
    {cpu, value} = Nex.CPU.pop_stack_value(cpu)
    new_registers = StatusRegister.from_byte(cpu.registers.status, value)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)
    {cpu, [high,low]} = Nex.CPU.pop_stack_values(cpu, 2)
    address = ((high <<< 8) + low)

    op_log = %{bytes: [], log: "RTI"}

    {Nex.CPU.update_pc(cpu, address), @cycles, op_log}
  end
end