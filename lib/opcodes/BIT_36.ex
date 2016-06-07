defmodule Nex.Opcodes.O36 do
  @moduledoc """
  BIT             BIT Test bits in memory with accumulator              BIT

  Operation:  A /\ M, M7 -> N, M6 -> V

  Bit 6 and 7 are transferred to the status register.   N Z C I D V
  If the result of A /\ M is zero then Z = 1, otherwise M7/ _ _ _ M6
  Z = 0
                               (Ref: 4.2.1.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Zero Page     |   BIT Oper            |    24   |    2    |    3     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 3
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    use Bitwise
    {cpu, [address]} = Nex.CPU.read_from_pc(cpu, 1)

    # get the memory value and shove them both into single bytes
    memory_value = Nex.CPU.retrieve(cpu, address)
    <<mem_byte::integer>> = <<memory_value::integer>>
    <<acc_byte::integer>> = <<cpu.registers.a::integer>>

    # set the new registers
    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(mem_byte)
      |> StatusRegister.set_overflow((mem_byte &&& 0b0100_0000) >>> 6)
      |> StatusRegister.set_zero(mem_byte &&& acc_byte)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)

    op_log = %{bytes: [address], log: format(address, memory_value)}
    {cpu, @cycles, op_log}
  end

  def format(address, old_value_for_logging) do
    "BIT $#{String.upcase(Hexate.encode(address, 2))} = #{Hexate.encode(old_value_for_logging,2)}"
  end
end