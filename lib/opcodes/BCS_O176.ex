defmodule Nex.Opcodes.O176 do
  require Logger
  @moduledoc """

  BCS                      BCS Branch on carry set                      BCS

  Operation:  Branch on C = 1                           N Z C I D V
                                                        _ _ _ _ _ _
                               (Ref: 4.1.1.4)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Relative      |   BCS Oper            |    B0   |    2    |    2*    |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if branch occurs to same  page.
  * Add 2 if branch occurs to next  page.
  """

  @cycles 2
  def run(cpu) do
    {cpu, [relative_address]} = Nex.CPU.read_from_pc(cpu, 1)
    absolute_jmp_address = cpu.registers.program_counter + relative_address
    Logger.info "[Opcode]\t#{format(absolute_jmp_address)}"
    next_addr = if cpu.registers.status.carry_flag == 1, do: absolute_jmp_address, else: cpu.registers.program_counter
    cycles = @cycles + (1 || 2) # TODO: Figure this out. Going to need a helper for pages.
    {Nex.CPU.update_pc(cpu, next_addr), @cycles}
  end

  def format(ops) do
    "BCS $#{String.upcase(Hexate.encode(ops))}"
  end
end