defmodule Xairo.FontExtents do
  @moduledoc """
    Models the font extents for a context's font at a given point, taking
    into account all font transformations (size, face, matrix)
  """

  defstruct [:ascent, :descent, :height, :max_x_advance, :max_y_advance]

  @type t :: %__MODULE__{
          ascent: number(),
          descent: number(),
          height: number(),
          max_x_advance: number(),
          max_y_advance: number()
        }

  alias Xairo.Context
  alias Xairo.Native, as: N

  def for(%Context{context: ctx}) do
    with {:ok, %__MODULE__{} = extents} <- N.font_extents_font_extents(ctx),
         do: extents
  end
end
