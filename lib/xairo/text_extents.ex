defmodule Xairo.TextExtents do
  @moduledoc """
    Models the extents for a string given the context's current font settings,
    taking into account all font transformations (size, family, matrix)
  """

  defstruct [:x_bearing, :y_bearing, :width, :height, :x_advance, :y_advance, :text]

  @type t :: %__MODULE__{
          x_bearing: number(),
          y_bearing: number(),
          width: number(),
          height: number(),
          x_advance: number(),
          y_advance: number(),
          text: String.t()
        }

  alias Xairo.Context
  alias Xairo.Native, as: N

  def for(%Context{context: ctx}, text) do
    with {:ok, %__MODULE__{} = extents} <- N.text_extents_text_extents(text, ctx),
         do: extents
  end
end
