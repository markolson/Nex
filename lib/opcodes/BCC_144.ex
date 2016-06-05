defmodule Nex.Opcodes.O144 do
  require Logger
  @moduledoc """
  BCC                     BCC Branch on Carry Clear                     BCC
                                                        N Z C I D V
  Operation:  Branch on C = 0                           _ _ _ _ _ _
                               (Ref: 4.1.1.3)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Relative      |   BCC Oper            |    90   |    2    |    2*    |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if branch occurs to same page.
  * Add 2 if branch occurs to different page.
  """

  @cycles 2
  def run(cpu) do
    {cpu, [jmp]} = Nex.CPU.read_from_pc(cpu, 1)
    absolute_jmp_address = cpu.registers.program_counter + Nex.Util.relative_value(jmp)
    next_addr = if cpu.registers.status.carry_flag == 0, do: absolute_jmp_address, else: cpu.registers.program_counter
    cycles = @cycles + (1 || 2) # TODO: Figure this out. Going to need a helper for pages.

    op_log = %{bytes: [jmp], log: format(absolute_jmp_address)}
    {Nex.CPU.update_pc(cpu, next_addr), @cycles, op_log}
  end

  def format(ops) do
    "BCC $#{String.upcase(Hexate.encode(ops))}"
  end
end