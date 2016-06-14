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
            internal_ram: List.duplicate(0x00, 0x0800),
            stack: List.duplicate(0, 0xFF),
            cartridge: nil

  def t do
    boot('test/roms/nestest/nestest.nes') |> flock
  end

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
    cpu_for_logger = cpu

    {cpu, [opcode]} = read_from_pc(cpu, 1)
    runner = Module.safe_concat(Nex.Opcodes, "O#{opcode}")
    {cpu, cycles, op_log} =  runner.run(cpu)
   # rescue
   #   _ -> raise "Failed on Op #{Hexate.encode(opcode)} (make lib/opcodes/XXX_#{opcode}.ex) at #{hpc(pc_for_logger)}"
   # end
    op_log = Map.put(op_log, :start_op, cpu_for_logger.registers.program_counter)
    Nex.Util.log(cpu_for_logger, %{op_log | bytes: [opcode | op_log.bytes] })
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

  def update_reg(cpu, reg, value) when is_integer(value) do
    new_registers = Map.put(cpu.registers, reg, value)
    Logger.debug "[CPU]\tSetting #{reg}: #{value}"
    %Nex.CPU{cpu | registers: new_registers}
  end

  def update_status_reg(cpu, status_register) do
    new_registers = %{cpu.registers | status: status_register}
    %Nex.CPU{cpu | registers: new_registers}
  end

  # $0800-$0FFF $0800 Mirrors of $0000-$07FF
  # $1000-$17FF $0800 Mirrors of $0000-$07FF
  # $1800-$1FFF $0800nMirrors of $0000-$07FF
  def store(cpu, address, value) when is_integer(value) do
    Logger.debug "[CPU]\tSTORE: $#{hpc(address)} = #{hpc(value)}"
    %Nex.CPU{cpu | internal_ram: List.replace_at(cpu.internal_ram, address, value)}
  end

  def retrieve(cpu, address) when is_integer(address) do
    value = Enum.at(cpu.internal_ram, address)
    Logger.debug "[CPU]\tFETCH: $#{hpc(address)} = #{hpc(value)}"
    value
  end

  def push_stack_value(cpu, value) when is_integer(value) do
    use Bitwise
    rp = cpu.registers.stack_pointer
    real_address = (0x01 <<< 8) + rp
    cpu = Nex.CPU.store(cpu, real_address, value)
    new_registers = %Nex.CPU.Registers{cpu.registers | stack_pointer: cpu.registers.stack_pointer - 1}
    %Nex.CPU{cpu | registers: new_registers}
  end

  def pop_stack_value(cpu) do
    use Bitwise
    new_registers = %Nex.CPU.Registers{cpu.registers | stack_pointer: cpu.registers.stack_pointer + 1}
    cpu = %Nex.CPU{cpu | registers: new_registers}
    real_address = (0x01 <<< 8) + cpu.registers.stack_pointer
    value = Nex.CPU.retrieve(cpu, real_address)
    {cpu, value}
  end

  def pop_stack_values(cpu, left \\ 1), do: pop_stack_values(cpu, left, [])
  def pop_stack_values(cpu, 0, result), do: {cpu, result}
  def pop_stack_values(cpu, left, result) do
    {cpu, value} = pop_stack_value(cpu)
    pop_stack_values(cpu, left-1, [value|result])
  end



  def hpc(%Nex.CPU{}=cpu), do: hpc(cpu.registers.program_counter)
  def hpc(x), do: Hexate.encode(x, 4) |> String.upcase
end