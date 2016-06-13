defmodule Elixir.Nex.Opcodes.O73 do
  @moduledoc """
    EOR            EOR "Exclusive-Or" memory with accumulator             EOR

  Operation:  A EOR M -> A                              N Z C I D V
                                                        / / _ _ _ _
                               (Ref: 2.2.3.2)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Immediate     |   EOR #Oper           |    49   |    2    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if page boundary is crossed.
  """


  @cycles 3
  def run(cpu) do
    use Bitwise
    alias Nex.CPU.StatusRegister
    {cpu, [value]} = Nex.CPU.read_from_pc(cpu, 1)
    nv = bxor(value, cpu.registers.a)
    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(nv)
      |> StatusRegister.set_zero(nv)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)
    op_log = %{bytes: [value], log: format(value)}
    {Nex.CPU.update_reg(cpu, :a, nv), @cycles, op_log}
  end
  
  def format(ops) do
    "EOR #$#{String.upcase(Hexate.encode(ops, 2))}"
  end
end