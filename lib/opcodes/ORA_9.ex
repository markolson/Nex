defmodule Nex.Opcodes.O9 do
  @moduledoc """
  ORA                 ORA "OR" memory with accumulator                  ORA

  Operation: A V M -> A                                 N Z C I D V
                                                        / / _ _ _ _
                               (Ref: 2.2.3.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Immediate     |   ORA #Oper           |    09   |    2    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 on page crossing
  """

  @cycles 3
  def run(cpu) do
    use Bitwise
    alias Nex.CPU.StatusRegister
    {cpu, [value]} = Nex.CPU.read_from_pc(cpu, 1)
    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(value)
      |> StatusRegister.set_zero(value)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)
    op_log = %{bytes: [value], log: format(value)}
    {Nex.CPU.update_reg(cpu, :a, (value ||| cpu.registers.a)), @cycles, op_log}
  end
  def format(ops) do
    "ORA #$#{String.upcase(Hexate.encode(ops, 2))}"
  end
end