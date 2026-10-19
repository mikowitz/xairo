defmodule Xairo.Rectangle do
  @moduledoc """
  Models a rectangle by providing the x and y coordinates of its upper left
  corner, and its width and height.
  """

  defstruct [:x, :y, :width, :height]

  @type t :: %__MODULE__{
          x: float(),
          y: float(),
          width: float(),
          height: float()
        }

  def new(x, y, width, height) do
    %__MODULE__{x: f(x), y: f(y), width: f(width), height: f(height)}
  end

  @doc false
  def from_nif(data), do: struct(__MODULE__, data)

  defp f(x), do: :erlang.float(x)
end
