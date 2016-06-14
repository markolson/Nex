defmodule Nex.Opcodes.O225 do
  @moduledoc """
  CMP                CMP Compare memory and accumulator                 CMP

  Operation:  A - M                                     N Z C I D V
                                                        / / / _ _ _
                                (Ref: 4.2.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  (Indirect,X)  |   CMP (Oper,X)        |    C1   |    2    |    6     |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if page boundary is crossed.
  """

  @cycles 6
  def run(cpu) do
    use Bitwise
    alias Nex.CPU.StatusRegister
    {cpu, [offset]} = Nex.CPU.read_from_pc(cpu, 1)
    x = cpu.registers.x

    <<zero_page_address::size(8), zp_next::size(8)>> = <<(x + offset)::size(8),(x + offset + 1)::size(8)>>
    mem_address = Nex.CPU.retrieve(cpu, zero_page_address) + (Nex.CPU.retrieve(cpu, zp_next)  <<< 8)
    value = Nex.CPU.retrieve(cpu, mem_address)

    ac = cpu.registers.a
    temp = ac - value - (if cpu.registers.status.carry_flag == 1, do: 0, else: 1)

    ac_mask = bor(ac, value) &&& 0x80
    tm_mask = bor(ac, temp) &&& 0x80
    overflowed = (ac_mask == 128 && tm_mask == 128)

    new_registers = cpu.registers.status 
      |> StatusRegister.set_zero(temp) 
      |> StatusRegister.set_negative(temp)
      |> StatusRegister.set_overflow(overflowed)

    temp = if cpu.registers.status.decimal_mode == 1 do
      temp = if ( (ac &&& 0xF) - (if cpu.registers.status.carry_flag == 1, do: 0, else: 1) < (value &&& 0xF) ), do: temp - 6, else: temp
      temp = if (temp > 0x99), do: temp - 0x60, else: temp
      temp
    else
      temp
    end
    new_registers = new_registers |> StatusRegister.set_carry(temp >= 0)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)
    
    op_log = %{bytes: [value], log: format(offset, zero_page_address, mem_address, value)}
    <<end_value::size(8),_::binary>> = <<temp>>
    {Nex.CPU.update_reg(cpu, :a, end_value), @cycles, op_log}
  end

  def format(offset, zero_page_address, mem_address, value) do
    #LDA ($80,X) @ 80 = 0200 = 5A
    "SBC ($#{String.upcase(Hexate.encode(offset))},X) @ #{String.upcase(Hexate.encode(zero_page_address))} = #{String.upcase(Hexate.encode(mem_address, 4))} = #{String.upcase(Hexate.encode(value, 2))}"
  end
end