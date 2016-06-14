defmodule Nex.Opcodes.O173 do
  @moduledoc """
  LDA                  LDA Load accumulator with memory                 LDA

  Operation:  M -> A                                    N Z C I D V
                                                        / / _ _ _ _
                                (Ref: 2.1.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Absolute      |   LDA Oper            |    AD   |    3    |    4     |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if page boundary is crossed.
  """

  @cycles 4
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
    {Nex.CPU.update_reg(cpu, :a, value), @cycles, op_log}
  end

  def format(address, value) do
    "LDA $#{String.upcase(Hexate.encode(address, 4))} = #{String.upcase(Hexate.encode(value, 2))}"
  end
end