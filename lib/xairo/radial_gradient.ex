defmodule Xairo.RadialGradient do
  @moduledoc """
    Models a radial gradient that can be set as a drawing surface's
    color source.
  """
  defstruct [:pattern]

  alias Xairo.Native, as: N
  alias Xairo.Rgba

  def new(x1, y1, r1, x2, y2, r2) do
    %__MODULE__{
      pattern: N.radial_gradient_new(x1 / 1, y1 / 1, r1 / 1, x2 / 1, y2 / 1, r2 / 1)
    }
  end

  def radial_circles(%__MODULE__{pattern: pattern}) do
    with {:ok, circles} <- N.radial_gradient_radial_circles(pattern), do: circles
  end

  def color_stop_count(%__MODULE__{pattern: pattern}) do
    with {:ok, count} <- N.radial_gradient_color_stop_count(pattern), do: count
  end

  def add_color_stop(%__MODULE__{pattern: pattern} = this, offset, %Rgba{} = rgba) do
    N.radial_gradient_add_color_stop(pattern, offset / 1, rgba)
    this
  end

  def color_stop_rgba(%__MODULE__{pattern: pattern}, index) do
    with {:ok, rgba} <- N.radial_gradient_color_stop_rgba(pattern, index),
         do: rgba
  end
end
