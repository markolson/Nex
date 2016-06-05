defmodule Nex.Opcodes.O56Test do
  use ExUnit.Case, async: true

  setup do
    cpu = Nex.Test.burn([0x38, 0xEA])
    {:ok, cpu: cpu}
  end

  test "SEC sets the Carry flag", %{cpu: cpu} do
    assert cpu.registers.status.carry_flag == 0
    {cpu, 2} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.status.carry_flag == 1
  end
end