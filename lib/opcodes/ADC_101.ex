defmodule Nex.Opcodes.O101 do
  @moduledoc """
  ADC               Add memory to accumulator with carry                ADC

  Operation:  A + M + C -> A, C                         N Z C I D V
                                                        / / / _ _ /
                                (Ref: 2.2.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Zero Page     |   ADC Oper            |    65   |    2    |    3     |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 if page boundary is crossed.
  """

  @cycles 3
  def run(cpu) do
    use Bitwise
    alias Nex.CPU.StatusRegister
    {cpu, [address]} = Nex.CPU.read_from_pc(cpu, 1)
    value = Nex.CPU.retrieve(cpu, address)
    
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

    op_log = %{bytes: [value], log: format(address, value)}
    <<end_value::size(8),_::binary>> = <<temp>>
    {Nex.CPU.update_reg(cpu, :a, end_value), @cycles, op_log}
  end

  def format(address, old_value_for_logging) do
    "ADC $#{String.upcase(Hexate.encode(address, 2))} = #{Hexate.encode(old_value_for_logging,2)}"
  end
end