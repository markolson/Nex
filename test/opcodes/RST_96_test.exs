defmodule Nex.Opcodes.O96Test do
  use ExUnit.Case, async: true

  setup do
    cpu = Nex.Test.burn([0x60, 0x00, 0x00, 0x38])
    {:ok, cpu: cpu}
  end

  test "JSR sets a return code in the stack", %{cpu: cpu} do
    cpu = Nex.CPU.push_stack_value(cpu, 0x00) |> Nex.CPU.push_stack_value(0x02)

    {cpu, 6} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.program_counter == 0x0003

    {cpu, _} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.status.carry_flag == 1
  end
end