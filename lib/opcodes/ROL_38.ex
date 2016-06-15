defmodule Nex.Opcodes.O38 do
  @moduledoc """
  ROL          ROL Rotate one bit left (memory or accumulator)          ROL

               +------------------------------+
               |         M or A               |
               |   +-+-+-+-+-+-+-+-+    +-+   |
  Operation:   +-< |7|6|5|4|3|2|1|0| <- |C| <-+         N Z C I D V
                   +-+-+-+-+-+-+-+-+    +-+             / / / _ _ _
                                 (Ref: 10.3)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Zero Page     |   ROL Oper            |    26   |    2    |    5     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    use Bitwise
    {cpu, [address]} = Nex.CPU.read_from_pc(cpu, 1)
    value = Nex.CPU.retrieve(cpu, address)

    nv = (value <<< 1) ^^^ cpu.registers.status.carry_flag
    
    new_registers = cpu.registers.status |> StatusRegister.set_carry(nv > 0xFF)

    <<nv::size(8),_::binary>> = <<nv>>

    new_registers = new_registers |> StatusRegister.set_negative(nv) |> StatusRegister.set_zero(nv)
      
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)
    cpu = Nex.CPU.store(cpu, address, nv)
    
    op_log = %{bytes: [address], log: format(address, value)}
    {cpu, @cycles, op_log}
  end

  def format(address, value) do
    "ROL $#{String.upcase(Hexate.encode(address, 2))} = #{String.upcase(Hexate.encode(value, 2))}"
  end
end