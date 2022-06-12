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

  @doc """
  Creates an RGBA color from float values for red, green, blue, and optionally
  alpha.

  When no alpha value is provided, the color defaults to fully opaque.

      iex> Rgba.new(0.5, 0, 1.0)
      %Rgba{ red: 0.5, green: 0.0, blue: 1.0, alpha: 1.0 }

  Values outside of the range [0, 1] are clamped to that range.

      iex> Rgba.new(1.3, 0, -0.5)
      %Rgba{ red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0 }

  """
  @spec new(number(), number(), number(), number() | nil) :: __MODULE__.t()

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
