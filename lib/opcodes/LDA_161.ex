defmodule Nex.Opcodes.O161 do
  @moduledoc """
  LDA                  LDA Load accumulator with memory                 LDA

  Operation:  M -> A                                    N Z C I D V
                                                        / / _ _ _ _
                                (Ref: 2.1.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  (Indirect,X)  |   LDA (Oper,X)        |    A1   |    2    |    6     |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if page boundary is crossed.
  """

  # INDIRECT
  @cycles 6
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    use Bitwise
s = """
CFF0  A2 00     LDX #$00                        A:5C X:03 Y:69 P:27 SP:FB CYC:226
CFF2  A1 FF     LDA ($FF,X) @ FF = 0400 = 5D    A:5C X:00 Y:69 P:27 SP:FB CYC:232
"""
    {cpu, [offset]} = Nex.CPU.read_from_pc(cpu, 1)
    x = cpu.registers.x

    # eg. FF + 2 = 0001 not 0101 as you might expect.
    <<zero_page_address::size(8), zp_next::size(8)>> = <<(x + offset)::size(8),(x + offset + 1)::size(8)>>
    mem_address = Nex.CPU.retrieve(cpu, zero_page_address) + (Nex.CPU.retrieve(cpu, zp_next)  <<< 8)
    value = Nex.CPU.retrieve(cpu, mem_address)

    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(value)
      |> StatusRegister.set_zero(value)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)

    op_log = %{bytes: [offset], log: format(offset, zero_page_address, mem_address, value)}
    {Nex.CPU.update_reg(cpu, :a, value), @cycles, op_log}
  end

  def format(offset, zero_page_address, mem_address, value) do
    #LDA ($80,X) @ 80 = 0200 = 5A
    "LDA ($#{String.upcase(Hexate.encode(offset))},X) @ #{String.upcase(Hexate.encode(zero_page_address))} = #{String.upcase(Hexate.encode(mem_address, 4))} = #{String.upcase(Hexate.encode(value, 2))}"
  end
end