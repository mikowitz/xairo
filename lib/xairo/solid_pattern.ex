defmodule Xairo.SolidPattern do
  @moduledoc """
  Models a color source for a drawing surface that contains a single color
  in RGB(A) format.
  """

  defstruct [:pattern]

  @type t :: %__MODULE__{
          pattern: reference()
        }

  alias Xairo.Native, as: N
  alias Xairo.Rgba

  @doc """
  Constructs a `__MODULE__` from a single `Xaior.Rgba` struct.
  """
  @spec from_rgba(Rgba.t()) :: t()
  def from_rgba(%Rgba{} = rgba) do
    %__MODULE__{
      pattern: N.solid_pattern_from_rgba(rgba)
    }
  end

  @doc """
  Returns the pattern's `Xairo.Rgba` value
  """
  @spec rgba(t()) :: Rgba.t()
  def rgba(%__MODULE__{pattern: pattern}) do
    with {:ok, rgba} <- N.solid_pattern_rgba(pattern), do: rgba
  end
end
