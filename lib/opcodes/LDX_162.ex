defmodule Nex.Opcodes.O162 do
  require Logger
  @moduledoc """

  LDX                   LDX Load index X with memory                    LDX

  Operation:  M -> X                                    N Z C I D V
                                                        / / _ _ _ _
                                 (Ref: 7.0)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Immediate     |   LDX #Oper           |    A2   |    2    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    {cpu, [value]} = Nex.CPU.read_from_pc(cpu, 1)
    Logger.debug "[Opcode]\t#{format(value)}"
    {Nex.CPU.update_x(cpu, value), @cycles}
  end

  def format(ops) do
    "LDX #$#{String.upcase(Hexate.encode(ops, 2))}"
  end
end