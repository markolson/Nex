defmodule Nex.Opcodes.DumbStackRegisters do
  use ExUnit.Case, async: true

  test "the dumb thing does what it needs to" do
  # http://wiki.nesdev.com/w/index.php/Status_flags
    cpu = Nex.Test.burn([
      0xA9, 0x00,    # LDA #$00
      0x48,          # Push $00 onto the stack
      0x28,          # clears all 6 (??) status flags
      0x08,          # pushes $30 on stack
      0x68           # pops the $30 off the stack
    ])
    
    {cpu, 2} = Nex.CPU.run_instruction(cpu)
    {cpu, _} = Nex.CPU.run_instruction(cpu)
    {cpu, _} = Nex.CPU.run_instruction(cpu)
    {cpu, _} = Nex.CPU.run_instruction(cpu)
    {cpu, _} = Nex.CPU.run_instruction(cpu)
    assert cpu.registers.a == 0x30
  end
end