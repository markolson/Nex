defmodule Nex.Opcodes.O129 do
  @moduledoc """
  STA                  STA Store accumulator in memory                  STA

  Operation:  A -> M                                    N Z C I D V
                                                        _ _ _ _ _ _
                                (Ref: 2.1.2)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  (Indirect,X)  |   STA (Oper,X)        |    81   |    2    |    6     |
  +----------------+-----------------------+---------+---------+----------+
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
    existing_value = Nex.CPU.retrieve(cpu, mem_address)
    cpu = Nex.CPU.store(cpu, mem_address, cpu.registers.a)

    op_log = %{bytes: [offset], log: format(offset, zero_page_address, mem_address, existing_value)}
    {cpu, @cycles, op_log}
  end

  def format(offset, zero_page_address, mem_address, value) do
    #LDA ($80,X) @ 80 = 0200 = 5A
    "STA ($#{String.upcase(Hexate.encode(offset))},X) @ #{String.upcase(Hexate.encode(zero_page_address))} = #{String.upcase(Hexate.encode(mem_address, 4))} = #{String.upcase(Hexate.encode(value, 2))}"
  end
end