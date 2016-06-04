defmodule Nex.Opcodes.O76Test do
  use ExUnit.Case, async: true

  setup do
    cpu = Nex.Test.burn([0x4C,0x06,0x00,0x00,0x00,0x00,0x4C,0x00,0x00])
    {:ok, cpu: cpu}
  end

  test "JMP sets a new PC", %{cpu: cpu} do
    {cpu, 3} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.program_counter == 0x0006
    {cpu, 3} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.program_counter == 0x0000
  end
end