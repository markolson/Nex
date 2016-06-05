defmodule Nex.CPU do
  require Logger
	@moduledoc """
	6502 Microprocessor, maybe.
	"""
  defstruct registers: %Nex.CPU.Registers{
                program_counter: 0x8000,
                stack_pointer: 0xFD,
                status: %Nex.CPU.StatusRegister{}
            },
            internal_ram: List.duplicate(255, 0x0800),
            stack: List.duplicate(0, 0xFF),
            cartridge: nil

  def boot(cartridge_path) do
    cart = Nex.Cartridge.load(cartridge_path)
    Logger.debug "[CPU]\tBooted"
    %Nex.CPU{cartridge: cart}
  end

  def flock(cpu) do
    {new_state, halt_for} = cpu |> run_instruction
    flock(new_state)
  end

  def run_instruction(cpu) do
    pc_for_logger = cpu.registers.program_counter

    {cpu, [opcode]} = read_from_pc(cpu, 1)
    runner = Module.safe_concat(Nex.Opcodes, "O#{opcode}")
    {cpu, cycles, op_log} = runner.run(cpu)
    op_log = Map.put(op_log, :start_op, pc_for_logger)
    Nex.Util.log(cpu, %{op_log | bytes: [opcode | op_log.bytes] })
    {cpu, cycles}
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

  def update_reg(cpu, reg, value) do
    new_registers = Map.put(cpu.registers, reg, value)
    Logger.debug "[CPU]\t#{reg}: #{value}"
    %Nex.CPU{cpu | registers: new_registers}
  end

  def update_status_reg(cpu, status_register) do
    new_registers = %{cpu.registers | status: status_register}
    %Nex.CPU{cpu | registers: new_registers}
  end

  # $0800-$0FFF $0800 Mirrors of $0000-$07FF
  # $1000-$17FF $0800 Mirrors of $0000-$07FF
  # $1800-$1FFF $0800nMirrors of $0000-$07FF
  def store(cpu, address, value) do
    Logger.debug "[CPU]\tRAM: $#{hpc(address)} = #{hpc(value)}"
    %Nex.CPU{cpu | internal_ram: List.replace_at(cpu.internal_ram, address, value)}
  end

  def push_stack_value(cpu, value) do
    cpu = %Nex.CPU{cpu | stack: List.replace_at(cpu.stack, cpu.registers.stack_pointer, value)}
    new_registers = %Nex.CPU.Registers{cpu.registers | stack_pointer: cpu.registers.stack_pointer - 1}
    %Nex.CPU{cpu | registers: new_registers}
  end

  def hpc(%Nex.CPU{}=cpu), do: hpc(cpu.registers.program_counter)
  def hpc(x), do: Hexate.encode(x, 4) |> String.upcase
end