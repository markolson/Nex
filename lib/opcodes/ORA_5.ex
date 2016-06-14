defmodule Nex.Opcodes.O5 do
  @moduledoc """
  ORA                 ORA "OR" memory with accumulator                  ORA

  Operation: A V M -> A                                 N Z C I D V
                                                        / / _ _ _ _
                               (Ref: 2.2.3.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Zero Page     |   ORA Oper            |    05   |    2    |    3     |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 on page crossing
  """

  @cycles 3
  def run(cpu) do
    use Bitwise
    alias Nex.CPU.StatusRegister
    {cpu, [address]} = Nex.CPU.read_from_pc(cpu, 1)
    value = Nex.CPU.retrieve(cpu, address)

    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(value)
      |> StatusRegister.set_zero(value)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)
    op_log = %{bytes: [value], log: format(address, value)}
    {Nex.CPU.update_reg(cpu, :a, (value ||| cpu.registers.a)), @cycles, op_log}
  end

  def format(address, value) do
    "ORA $#{String.upcase(Hexate.encode(address, 2))} = #{String.upcase(Hexate.encode(value, 2))}"
  end
end