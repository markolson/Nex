defmodule Nex.Util do
  """
    eg  bit no.  7 6 5 4 3 2 1 0    signed value          unsigned value
      value    1 0 1 0 0 1 1 1    -39                   $A7
      value    0 0 1 0 0 1 1 1    +39                   $27
  """
  def relative_value(value) when is_integer(value), do: relative_value(<<value::integer>>)
  def relative_value(<<1::size(1), rest::size(7)>>), do: 0 - rest
  def relative_value(<<0::size(1), rest::size(7)>>), do: rest
end
