defmodule Xairo.Enums do
  def enum_type(enum) do
    enum
    |> Enum.reverse()
    |> Enum.reduce(&{:|, [], [&1, &2]})
  end
end
