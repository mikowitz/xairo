defmodule Xairo.LinearGradient do
  @moduledoc """
    Models a linear griadent that can be set as a surface's color source.
  """
  defstruct [:pattern]

  alias Xairo.Native, as: N

  def new(x1, y1, x2, y2) do
    %__MODULE__{
      pattern: N.linear_gradient_new(x1 / 1, y1 / 1, x2 / 1, y2 / 1)
    }
  end

  def linear_points(%__MODULE__{pattern: pattern}) do
    with {:ok, points} <- N.linear_gradient_linear_points(pattern), do: points
  end

  def color_stop_count(%__MODULE__{pattern: pattern}) do
    with {:ok, count} <- N.linear_gradient_color_stop_count(pattern), do: count
  end

  def add_color_stop_rgb(%__MODULE__{pattern: pattern} = this, offset, red, green, blue) do
    N.linear_gradient_add_color_stop_rgb(pattern, offset / 1, red / 1, green / 1, blue / 1)
    this
  end

  def add_color_stop_rgba(%__MODULE__{pattern: pattern} = this, offset, red, green, blue, alpha) do
    N.linear_gradient_add_color_stop_rgba(
      pattern,
      offset / 1,
      red / 1,
      green / 1,
      blue / 1,
      alpha / 1
    )

    this
  end

  def color_stop_rgba(%__MODULE__{pattern: pattern}, index) do
    with {:ok, rgba} <- N.linear_gradient_color_stop_rgba(pattern, index),
         do: rgba
  end
end
