defmodule Nex.Opcodes.O38 do
  require Logger
  @moduledoc """
  SEC                        SEC Set carry flag                         SEC

  Operation:  1 -> C                                    N Z C I D V
                                                        _ _ 1 _ _ _
                                (Ref: 3.0.1)
  +----------------+-----------------------+---------+---------+----------+
  | Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
  +----------------+-----------------------+---------+---------+----------+
  |  Implied       |   SEC                 |    38   |    1    |    2     |
  +----------------+-----------------------+---------+---------+----------+
  """

  @cycles 2
  def run(cpu) do
    Logger.debug "[Opcode]\t#{format()}"
    # TODO: Do the thing
  end

  def format(ops \\ []) do
    "SEC"
  end
end