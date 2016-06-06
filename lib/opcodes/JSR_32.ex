defmodule Nex.Opcodes.O32 do
  require Logger
  @moduledoc """

  JSR          JSR Jump to new location saving return address           JSR

  Operation:  PC + 2 toS, (PC + 1) -> PCL               N Z C I D V
                          (PC + 2) -> PCH               _ _ _ _ _ _
                                 (Ref: 8.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Absolute      |   JSR Oper            |    20   |    3    |    6     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 6
  def run(cpu) do
    use Bitwise
    <<pc_high::size(8),pc_low::size(8)>> = <<cpu.registers.program_counter-1::size(16)>>
    {cpu, [low, high]} = Nex.CPU.read_from_pc(cpu, 2)
    absolute_jmp_address = (high <<< 8) ||| low

    # TODO: this is probably backwards lol
    cpu = Nex.CPU.push_stack_value(cpu, pc_high)
    cpu = Nex.CPU.push_stack_value(cpu, pc_low)

    op_log = %{bytes: [low, high], log: format(absolute_jmp_address)}
    {Nex.CPU.update_pc(cpu, absolute_jmp_address), @cycles, op_log}
  end

  def format(ops) do
    "JSR $#{String.upcase(Hexate.encode(ops, 2))}"
  end
end