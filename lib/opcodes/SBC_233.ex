defmodule Nex.Opcodes.O233 do
  @moduledoc """
  SBC          SBC Subtract memory from accumulator with borrow         SBC
                      -
  Operation:  A - M - C -> A                            N Z C I D V
         -                                              / / / _ _ /
    Note:C = Borrow             (Ref: 2.2.2)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Immediate     |   SBC #Oper           |    E9   |    2    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  * Add 1 when page boundary is crossed.
  """

  @cycles 3
  def run(cpu) do
    use Bitwise
    alias Nex.CPU.StatusRegister
    {cpu, [value]} = Nex.CPU.read_from_pc(cpu, 1)
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
    
    op_log = %{bytes: [value], log: format(value)}
    <<end_value::size(8),_::binary>> = <<temp>>
    {Nex.CPU.update_reg(cpu, :a, end_value), @cycles, op_log}
  end
  def format(ops) do
    "SBC #$#{String.upcase(Hexate.encode(ops, 2))}"
  end
end