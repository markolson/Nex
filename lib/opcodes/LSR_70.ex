defmodule Nex.Opcodes.O70 do
  @moduledoc """
  LSR          LSR Shift right one bit (memory or accumulator)          LSR

                   +-+-+-+-+-+-+-+-+
  Operation:  0 -> |7|6|5|4|3|2|1|0| -> C               N Z C I D V
                   +-+-+-+-+-+-+-+-+                    0 / / _ _ _
                                 (Ref: 10.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Zero Page     |   LSR Oper            |    46   |    2    |    5     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    use Bitwise
    {cpu, [address]} = Nex.CPU.read_from_pc(cpu, 1)
    value = Nex.CPU.retrieve(cpu, address)
    nv = (value >>> 1)

    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(nv)
      |> StatusRegister.set_zero(nv)
      |> StatusRegister.set_carry((cpu.registers.a &&& 0b0000_0001) == 1)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)
    cpu = Nex.CPU.store(cpu, address, nv)

    op_log = %{bytes: [value], log: format(address, value)}
    {cpu, @cycles, op_log}
  end

  def format(address, old_value_for_logging) do
    "LSR $#{String.upcase(Hexate.encode(address, 2))} = #{Hexate.encode(old_value_for_logging,2)}"
  end
end