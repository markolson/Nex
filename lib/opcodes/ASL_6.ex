defmodule Nex.Opcodes.O6 do
  @moduledoc """
  ASL          ASL Shift Left One Bit (Memory or Accumulator)           ASL
                   +-+-+-+-+-+-+-+-+
  Operation:  C <- |7|6|5|4|3|2|1|0| <- 0
                   +-+-+-+-+-+-+-+-+                    N Z C I D V
                                                        / / / _ _ _
                                 (Ref: 10.2)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Zero Page     |   ASL Oper            |    06   |    2    |    5     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 5
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    use Bitwise
    {cpu, [address]} = Nex.CPU.read_from_pc(cpu, 1)
    value = Nex.CPU.retrieve(cpu, address)
    nv = (value <<< 1)
    <<nv::size(8),_::binary>> = <<nv>>

    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(nv)
      |> StatusRegister.set_zero(nv)
      |> StatusRegister.set_carry((value &&& 0b1000_0000) == 128)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)
    cpu = Nex.CPU.store(cpu, address, nv)

    op_log = %{bytes: [address], log: format(address, value)}
    {cpu, @cycles, op_log}
  end  

  def format(address, value) do
    "ASL $#{String.upcase(Hexate.encode(address, 2))} = #{String.upcase(Hexate.encode(value, 2))}"
  end
end