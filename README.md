# NEX

Elixir/OpenGL NES Emulator, because why the heck not.
All technology is pointless.


## Short-term TODO list

* Turn CPU into a Genserver
* Initialize CPU registers


## Notes

NesTest is a NROM-128 with no mapper
 > In NROM-128, the 16k PRG ROM is mirrored into both $8000-$BFFF and $C000-$FFFF.
So execution can start at C000, which is really location 0000 in the ROM itself. 
What have I gotten myself into. Mappers are going to require some thought...



```
t = Nex.CPU.boot("test/roms/nestest/nestest.nes")
Nex.CPU.run_instruction(t)
```