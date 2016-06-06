defmodule Nex.Opcodes.O32Test do
  use ExUnit.Case, async: true

  setup do
    cpu = Nex.Test.burn([0x20, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x38])
    {:ok, cpu: cpu}
  end

  test "JSR sets a return code in the stack", %{cpu: cpu} do
    {cpu, 6} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.program_counter == 0x0007
    # bit shifting is boooooooring
    pop_back = Enum.slice(cpu.stack, cpu.registers.stack_pointer + 1, 2) |> Enum.reverse |> Hexate.encode
    assert pop_back == "8000"

    {cpu, _} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.status.carry_flag == 1
  end
end