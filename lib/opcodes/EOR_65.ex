defmodule Elixir.Nex.Opcodes.O65 do
  @moduledoc """
    EOR            EOR "Exclusive-Or" memory with accumulator             EOR

  Operation:  A EOR M -> A                              N Z C I D V
                                                        / / _ _ _ _
                               (Ref: 2.2.3.2)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  (Indirect,X)  |   EOR (Oper,X)        |    41   |    2    |    6     |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if page boundary is crossed.
  """

  # INDIRECT
  @cycles 6
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    use Bitwise
    {cpu, [offset]} = Nex.CPU.read_from_pc(cpu, 1)
    x = cpu.registers.x

    # eg. FF + 2 = 0001 not 0101 as you might expect.
    <<zero_page_address::size(8), zp_next::size(8)>> = <<(x + offset)::size(8),(x + offset + 1)::size(8)>>
    mem_address = Nex.CPU.retrieve(cpu, zero_page_address) + (Nex.CPU.retrieve(cpu, zp_next)  <<< 8)
    value = Nex.CPU.retrieve(cpu, mem_address)

    new_value = (value ^^^ cpu.registers.a)
    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(new_value)
      |> StatusRegister.set_zero(new_value)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)

    op_log = %{bytes: [offset], log: format(offset, zero_page_address, mem_address, value)}
    {Nex.CPU.update_reg(cpu, :a, new_value), @cycles, op_log}
  end

  def format(offset, zero_page_address, mem_address, value) do
    #LDA ($80,X) @ 80 = 0200 = 5A
    "EOR ($#{String.upcase(Hexate.encode(offset))},X) @ #{String.upcase(Hexate.encode(zero_page_address))} = #{String.upcase(Hexate.encode(mem_address, 4))} = #{String.upcase(Hexate.encode(value, 2))}"
  end
end