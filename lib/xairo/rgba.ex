defmodule Xairo.Rgba do
  @moduledoc """
    Models a color in RGBA colorspace.
  """

  defstruct [:red, :green, :blue, :alpha]

  @type t :: %__MODULE__{
          red: number(),
          green: number(),
          blue: number(),
          alpha: number()
        }

  def new(red, green, blue, alpha \\ 1.0) do
    %__MODULE__{
      red: clamp(red),
      green: clamp(green),
      blue: clamp(blue),
      alpha: clamp(alpha)
    }
  end

  defp clamp(x) when x < 0, do: 0.0
  defp clamp(x) when x > 1, do: 1.0
  defp clamp(x), do: x / 1
end
