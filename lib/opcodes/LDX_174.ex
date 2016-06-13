defmodule Nex.Opcodes.O174 do
  @moduledoc """

  LDX                   LDX Load index X with memory                    LDX

  Operation:  M -> X                                    N Z C I D V
                                                        / / _ _ _ _
                                 (Ref: 7.0)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Absolute      |   LDX Oper            |    AE   |    3    |    4     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    use Bitwise

    {cpu, [low, high]} = Nex.CPU.read_from_pc(cpu, 2)
    address = (high <<< 8) ||| low
    value = Nex.CPU.retrieve(cpu, address)

    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(value)
      |> StatusRegister.set_zero(value)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)

    op_log = %{bytes: [low, high], log: format(address, value)}
    {Nex.CPU.update_reg(cpu, :x, value), @cycles, op_log}
  end

  def format(address, value) do
    "LDX $#{String.upcase(Hexate.encode(address, 4))} = #{String.upcase(Hexate.encode(value, 2))}"
  end
end