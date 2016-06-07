defmodule Nex.Opcodes.O126Test do
  use ExUnit.Case, async: true

  test "LDX loads an immediate value" do
    {cpu, 2} = Nex.Test.burn([0xA2,0xFF]) |> Nex.CPU.run_instruction
    assert cpu.registers.x == 0xFF
    {cpu, 2} = Nex.Test.burn([0xA2,0x09]) |> Nex.CPU.run_instruction
    assert cpu.registers.x == 0x09
  end

  test "LDX sets the Zero flag" do
    {cpu, 2} = Nex.Test.burn([0xA2,0x00]) |> Nex.CPU.run_instruction
    assert cpu.registers.status.zero_result == 1
  end

  test "LDX clears the Zero flag" do
    {cpu, 2} = Nex.Test.burn([0xA2,0xFF]) |> Nex.CPU.run_instruction
    assert cpu.registers.status.zero_result == 0
  end

  test "LDX sets the Negative flag" do
    {cpu, 2} = Nex.Test.burn([0xA2,0xFF]) |> Nex.CPU.run_instruction
    assert cpu.registers.status.sign_flag == 1
  end

  test "LDX clears the Negative flag" do
    {cpu, 2} = Nex.Test.burn([0xA2,0x7F]) |> Nex.CPU.run_instruction
    assert cpu.registers.status.sign_flag == 0
  end
end