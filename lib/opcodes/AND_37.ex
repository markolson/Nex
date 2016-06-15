defmodule Nex.Opcodes.O37 do
  @moduledoc """
  AND                  "AND" memory with accumulator                    AND

  Operation:  A /\ M -> A                               N Z C I D V
                                                        / / _ _ _ _
                               (Ref: 2.2.3.0)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Zero Page     |   AND Oper            |    25   |    2    |    3     |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if page boundary is crossed.
  """

  @cycles 3
  def run(cpu) do
    use Bitwise
    alias Nex.CPU.StatusRegister
    {cpu, [address]} = Nex.CPU.read_from_pc(cpu, 1)
    value = Nex.CPU.retrieve(cpu, address)

    nv = (value &&& cpu.registers.a)
    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(nv)
      |> StatusRegister.set_zero(nv)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)
    op_log = %{bytes: [address], log: format(address, value)}
    {Nex.CPU.update_reg(cpu, :a, nv), @cycles, op_log}
  end

  def format(address, value) do
    "AND $#{String.upcase(Hexate.encode(address, 2))} = #{String.upcase(Hexate.encode(value, 2))}"
  end
end