defmodule Nex.Opcodes.O36Test do
  use ExUnit.Case, async: true

  test "BIT sets the overflow flag based on the MEM value" do
    cpu = Nex.Test.burn([0x24, 0x01, 0xEA]) |> Nex.CPU.store(0x01, 0b0100_0000)
    {cpu, 3} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.status.overflow_flag == 1

    cpu = Nex.Test.burn([0x24, 0x01, 0xEA]) |>  Nex.CPU.store(0x01, 0b1011_1111)
    {cpu, 3} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.status.overflow_flag == 0
  end

  test "BIT sets the negative flag based on the MEM value" do
    cpu = Nex.Test.burn([0x24, 0x01, 0xEA]) |> Nex.CPU.store(0x01, 0b1000_0000)
    {cpu, 3} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.status.sign_flag == 1

    cpu = Nex.Test.burn([0x24, 0x01, 0xEA]) |>  Nex.CPU.store(0x01, 0b0111_1111)
    {cpu, 3} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.status.sign_flag == 0
  end

  test "BIT sets the zero flag based on ACC /\ MEM" do
    cpu = Nex.Test.burn([0x24, 0x01, 0xEA]) |> Nex.CPU.update_reg(:a, 0xFF) |> Nex.CPU.store(0x01, 0xFF)
    {cpu, 3} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.status.zero_result == 0

    cpu = Nex.Test.burn([0x24, 0x01, 0xEA]) |> Nex.CPU.update_reg(:a, 0b1010_1010) |> Nex.CPU.store(0x01, 0b0101_0101)
    {cpu, 3} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.status.zero_result == 1
  end
end