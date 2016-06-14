defmodule Nex.Opcodes.O97 do
  @moduledoc """
  ADC               Add memory to accumulator with carry                ADC

  Operation:  A + M + C -> A, C                         N Z C I D V
                                                        / / / _ _ /
                                (Ref: 2.2.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  (Indirect,X)  |   ADC (Oper,X)        |    61   |    2    |    6     |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if page boundary is crossed.
  """

  @cycles 6
  def run(cpu) do
    use Bitwise
    alias Nex.CPU.StatusRegister
    {cpu, [offset]} = Nex.CPU.read_from_pc(cpu, 1)
    x = cpu.registers.x

    # eg. FF + 2 = 0001 not 0101 as you might expect.
    <<zero_page_address::size(8), zp_next::size(8)>> = <<(x + offset)::size(8),(x + offset + 1)::size(8)>>
    mem_address = Nex.CPU.retrieve(cpu, zero_page_address) + (Nex.CPU.retrieve(cpu, zp_next)  <<< 8)
    value = Nex.CPU.retrieve(cpu, mem_address)

    ac = cpu.registers.a
    temp = value + ac + cpu.registers.status.carry_flag

    #overflowed = !(((bor(ac, value)) &&& 0x80) == 128 && ((bor(ac, temp)) &&& 0x80) == 128)
    ac_mask = bor(ac, value) &&& 0x80
    tm_mask = bor(ac, temp) &&& 0x80
    overflowed = (ac_mask != 128 && tm_mask == 128)
    
    nr = cpu.registers.status |> StatusRegister.set_zero(temp)

    {new_registers, temp} = if cpu.registers.status.decimal_mode == 1 do
      # if (((AC & 0xf) + (src & 0xf) + (IF_CARRY() ? 1 : 0)) > 9) temp += 6;
      # TODO: can't get this to work with nestest.log results..
      #temp = if ((ac &&& 0xF) + (value &&& 0xF) + cpu.registers.status.carry_flag > 9), do: temp + 6, else: temp
      nr = nr |> StatusRegister.set_negative(temp) |> StatusRegister.set_overflow(overflowed)
      temp = if (temp > 0x99), do: temp + 96, else: temp
      nr = nr |> StatusRegister.set_carry(temp > 0x99)
      {nr, temp}
    else
      nr = nr
        |> StatusRegister.set_negative(temp) 
        |> StatusRegister.set_overflow(overflowed)
        |> StatusRegister.set_carry(temp > 0xFF)
      {nr, temp}
    end
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)

    op_log = %{bytes: [value], log: format(offset, zero_page_address, mem_address, value)}
    <<end_value::size(8),_::binary>> = <<temp>>
    {Nex.CPU.update_reg(cpu, :a, end_value), @cycles, op_log}
  end

  def format(offset, zero_page_address, mem_address, value) do
    #LDA ($80,X) @ 80 = 0200 = 5A
    "EOR ($#{String.upcase(Hexate.encode(offset))},X) @ #{String.upcase(Hexate.encode(zero_page_address))} = #{String.upcase(Hexate.encode(mem_address, 4))} = #{String.upcase(Hexate.encode(value, 2))}"
  end
end