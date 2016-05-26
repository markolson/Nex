defmodule Nex.CPU do
  require Logger
	@moduledoc """
	6502 Microprocessor, maybe.
	"""
  defstruct registers: %Nex.CPU.Registers{
                program_counter: 0x8000,
                stack_pointer: 0xFD,
                status: nil # should be 24 but ugh
            },
            internal_ram: List.duplicate(255, 0x0800),
            cartridge: nil

  def boot(cartridge_path) do
    cart = Nex.Cartridge.load(cartridge_path)
    Logger.debug "[CPU]\tBooted"
    %Nex.CPU{cartridge: cart}
  end

  def run_instruction(cpu) do
    {cpu, [opcode]} = read_from_pc(cpu, 1)
    runner = Module.safe_concat(Nex.Opcodes, "O#{opcode}")
    {cpu, cycles} = runner.run(cpu)
  end

  def read_from_pc(cpu, size) do
    input = cpu.cartridge.mapper.read(cpu.cartridge.program, cpu.registers.program_counter, size)
    cpu = advance_pc(cpu, size)
    {cpu, input}
  end

  def advance_pc(cpu, by \\ 1) do
    update_pc(cpu, cpu.registers.program_counter + by)
  end

  def update_pc(cpu, to) do
    new_registers = %Nex.CPU.Registers{cpu.registers | program_counter: to}
    Logger.debug "[CPU]\tPC: $#{hpc(to)}"
    %Nex.CPU{cpu | registers: new_registers} 
  end

  def update_x(cpu, value) do
    #TODO: something like new_status = set_status_flags(cpu.registers.status, value) ?
    new_registers = %Nex.CPU.Registers{cpu.registers | x: value}
    Logger.debug "[CPU]\tX: #{value}"
    %Nex.CPU{cpu | registers: new_registers}
  end

  # $0800-$0FFF $0800 Mirrors of $0000-$07FF
  # $1000-$17FF $0800 Mirrors of $0000-$07FF
  # $1800-$1FFF $0800nMirrors of $0000-$07FF
  def store(cpu, address, value) do
    Logger.debug "[CPU]\tRAM: $#{hpc(address)} = #{hpc(value)}"
    %Nex.CPU{cpu | internal_ram: List.replace_at(cpu.internal_ram, address, value)}
  end

  def hpc(%Nex.CPU{}=cpu), do: hpc(cpu.registers.program_counter)
  def hpc(x), do: Hexate.encode(x, 4) |> String.upcase
end