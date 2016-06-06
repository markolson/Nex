defmodule Nex.Opcodes.ConditionalJump do
  def relative(cpu, cycles, flag, comparison, formatter) do
    {cpu, [jmp]} = Nex.CPU.read_from_pc(cpu, 1)
    absolute_jmp_address = cpu.registers.program_counter + Nex.Util.relative_value(jmp)
    next_addr = if flag == comparison, do: absolute_jmp_address, else: cpu.registers.program_counter
    cycles = cycles + (1 || 2) # TODO: Figure this out. Going to need a helper for pages.

    op_log = %{bytes: [jmp], log: formatter.(absolute_jmp_address)}
    {Nex.CPU.update_pc(cpu, next_addr), cycles, op_log}
  end
end