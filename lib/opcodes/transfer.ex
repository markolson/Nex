defmodule Nex.Opcodes.Transfer do
  def move(cpu, from, to, instruction) do
    alias Nex.CPU.StatusRegister
    value = Map.get(cpu.registers, from)
    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(value)
      |> StatusRegister.set_zero(value)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)
    
    op_log = %{bytes: [], log: instruction}
    {Nex.CPU.update_reg(cpu, to, value), @cycles, op_log}
  end
end