defmodule Nex.Opcodes.O76 do
  require Logger
  def run(cpu) do
    use Bitwise
    {cpu, [low, high]} = Nex.CPU.read_from_pc(cpu, 2)
    absolute_jmp_address = (high <<< 8) ||| low
    Logger.debug "[Opcode]\t#{format(absolute_jmp_address)}"
    Nex.CPU.update_pc(cpu, absolute_jmp_address)
  end

  def format(ops) do
    "JMP $#{String.upcase(Hexate.encode(ops))}"
  end
end