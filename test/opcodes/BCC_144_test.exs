defmodule Nex.Opcodes.O144Test do
  use ExUnit.Case, async: true

  setup do
    cpu = Nex.Test.burn([
      0xA2, 0xAA,      # set the x register
      0x90, 0x02,      # jump forward past the load if carry is not set
      0xA2, 0xAF,      # set the x register ... again
      0xEA             # nop
    ])
    {:ok, cpu: cpu}
  end

  test "BCC does jump if Carry is not set", %{cpu: cpu} do
    {cpu, _} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.x == 0xAA # verify the initial x state
    {cpu, _} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.program_counter == 0x8006
    {cpu, _} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.x == 0xAA # verify the intiail x state, again
  end

  test "BCC does not jump if Carry is set", %{cpu: cpu} do
    cpu = Nex.CPU.update_status_reg(cpu, Nex.CPU.StatusRegister.set_carry(cpu.registers.status, true))
    {cpu, _} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.x == 0xAA # verify the initial x state
    {cpu, _} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.program_counter == 0x8004
    {cpu, _} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.x == 0xAF # verify the new x state
  end

  test "BCC will jump backwards if Carry is set and bit 7 of the jump address is not set" do
    cpu = Nex.Test.burn([0x00,0x00,0x90, 0x84]) # set up a stupid ROM
    cpu = Nex.CPU.advance_pc(cpu, 2) # start at our BCC
    assert cpu.registers.program_counter == 0x8002 # sanity check
    {cpu, _} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.program_counter == 0x8000
  end
end