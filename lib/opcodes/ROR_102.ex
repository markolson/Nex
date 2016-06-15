defmodule Nex.Opcodes.O102 do
  @moduledoc """
  ROR          ROR Rotate one bit right (memory or accumulator)         ROR

               +------------------------------+
               |                              |
               |   +-+    +-+-+-+-+-+-+-+-+   |
  Operation:   +-> |C| -> |7|6|5|4|3|2|1|0| >-+         N Z C I D V
                   +-+    +-+-+-+-+-+-+-+-+             / / / _ _ _
                                 (Ref: 10.4)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Zero Page     |   ROR Oper            |    66   |    2    |    5     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    alias Nex.CPU.StatusRegister
    use Bitwise
    {cpu, [address]} = Nex.CPU.read_from_pc(cpu, 1)
    value = Nex.CPU.retrieve(cpu, address)

    nv = (value ^^^ (cpu.registers.status.carry_flag <<< 8) >>> 1)

    new_registers = cpu.registers.status
      |> StatusRegister.set_negative(nv)
      |> StatusRegister.set_zero(nv)
      |> StatusRegister.set_carry((value &&& 0b0000_0001) == 1)
    cpu = Nex.CPU.update_status_reg(cpu, new_registers)
    cpu = Nex.CPU.store(cpu, address, nv)

    op_log = %{bytes: [address], log: format(address, value)}
    {cpu, @cycles, op_log}
  end

  def format(address, value) do
    "ROR $#{String.upcase(Hexate.encode(address, 2))} = #{String.upcase(Hexate.encode(value, 2))}"
  end
end