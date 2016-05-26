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
              interrupts_inhibit:     0,  # I, bit 2
              # Ignored on NES
              decimal_mode:           0,  # D, bit 3
              # sorta unused. PHP, BRK, /IRQ and /NMI push to 4 & 5
              brk_executed:           0,  # B, bit 4. 
              unused:                 0,  # bit 5
              # 1 if last ADC or SBC resulted in signed overflow,
              # or D6 from last BIT
              overflow_flag:          0,  # V, bit 6
              # Negative: Set to bit 7 of the last operation
              negative_result:        0   # S, bit 7
end

defmodule Nex.CPU.Registers do
  defstruct   acculator:              0,  # A, byte-wide
              x:                      0,  # X, byte-wide
              y:                      0,  # Y, byte-wide
              status:                 StatusRegister, # P, byte-wide
              program_counter:        0,  # PC, 2-byte
              stack_pointer:          0   # S, byte-wide
end