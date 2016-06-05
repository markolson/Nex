defmodule Nex.Opcodes.O24Test do
  use ExUnit.Case, async: true

  setup do
    cpu = Nex.Test.burn([0x18, 0xEA])
    cpu = Nex.CPU.update_status_reg(cpu, Nex.CPU.StatusRegister.set_carry(cpu.registers.status, true))
    {:ok, cpu: cpu}
  end

  test "SEC sets the Carry flag", %{cpu: cpu} do
    assert cpu.registers.status.carry_flag == 1
    {cpu, 2} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.status.carry_flag == 0
  end
end