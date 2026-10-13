defmodule Xairo.Enums do
  @moduledoc false
  def enum_type(enum) do
    enum
    |> Enum.reverse()
    |> Enum.reduce(&{:|, [], [&1, &2]})
  end
end
