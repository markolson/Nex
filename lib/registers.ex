# Is this abstraction of status register useful? We can just 
# name the bits in the elixir pattern match stuff, right?

# <<s::size(1),v::size(1),b::size(2),d::size(1),i::size(2),z::size(1),c::size(1)>> = <<register_byte::integer>>
defmodule Nex.CPU.StatusRegister do
              # 1 if last addition or shift resulted in a carry, or if
              # last subtraction resulted in no borrow
  defstruct   carry_flag:             0,  # C, bit 0
              # 1 if last operation resulted in a 0 value
              zero_result:            0,  # Z, bit 1
              # (0: /IRQ and /NMI get through; 1: only /NMI gets through)
              interrupts_inhibit:     1,  # I, bit 2
              # Ignored on NES
              decimal_mode:           0,  # D, bit 3
              # sorta unused. PHP, BRK, /IRQ and /NMI push to 4 & 5
              brk_executed:           0,  # B, bit 4. 
              unused:                 1,  # bit 5 (always on?)
              # 1 if last ADC or SBC resulted in signed overflow,
              # or D6 from last BIT
              overflow_flag:          0,  # V, bit 6
              # Negative: Set to bit 7 of the last operation
              sign_flag:        0   # S, bit 7

  def to_byte(register) do
    use Bitwise
    <<b::integer>> = <<
      register.sign_flag::size(1),
      register.overflow_flag::size(1),
      1::size(1),
      register.brk_executed::size(1),
      register.decimal_mode::size(1),
      register.interrupts_inhibit::size(1),
      register.zero_result::size(1),
      register.carry_flag::size(1),
    >>
    b
  end

  def to_hex(register), do: Nex.CPU.StatusRegister.to_byte(register) |> Hexate.encode(2) |> String.upcase

  def from_byte(byte) do
    <<
      n::size(1),
      o::size(1),
      1::size(1),
      b::size(1),
      d::size(1),
      i::size(1),
      z::size(1),
      c::size(1),
    >> = <<byte::integer>>
    %Nex.CPU.StatusRegister{
      sign_flag: n,
      overflow_flag: o,
      brk_executed: b,
      decimal_mode: d,
      interrupts_inhibit: i,
      zero_result: z,
      carry_flag: c
    }
  end

  def set_overflow(register, value) do
    %Nex.CPU.StatusRegister{ register | overflow_flag: (value > 0 && 1) || 0 }
  end

  def set_carry(register, value) do
    %Nex.CPU.StatusRegister{ register | carry_flag: (value == true && 1) || 0 }
  end

  def set_negative(register, value) do
    use Bitwise
    %Nex.CPU.StatusRegister{ register | sign_flag: ((value &&& 0b1000_0000 ) > 0 && 1) || 0 }
  end

  def set_zero(register, value) do
    %Nex.CPU.StatusRegister{ register | zero_result: (value == 0 && 1) || 0 }
  end

  def set_interrupt_disabled(register, value) do
    %Nex.CPU.StatusRegister{ register | interrupts_inhibit: (value == true && 1) || 0 }
  end

  def set_decimal_mode(register, value) do
    %Nex.CPU.StatusRegister{ register | decimal_mode: (value == true && 1) || 0 }
  end
end

defmodule Nex.CPU.Registers do
  defstruct   a:                      0,  # A, byte-wide
              x:                      0,  # X, byte-wide
              y:                      0,  # Y, byte-wide
              status:                 nil, # P, byte-wide
              program_counter:        0,  # PC, 2-byte
              stack_pointer:          0   # S, byte-wide
end