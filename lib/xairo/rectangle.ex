defmodule Xairo.Rectangle do
  @moduledoc false

  defstruct [:x, :y, :width, :height]

  def new(x, y, width, height) do
    %__MODULE__{x: f(x), y: f(y), width: f(width), height: f(height)}
  end

  @doc false
  def from_nif(data), do: struct(__MODULE__, data)

  defp f(x), do: :erlang.float(x)
end
