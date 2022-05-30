defmodule Xairo.FontFace do
  defstruct [:font_face]

  alias Xairo.Native, as: N

  def toy_create(family, slant, weight) do
    with {:ok, font_face} <- N.font_face_toy_create(family, slant, weight),
         do: %__MODULE__{font_face: font_face}
  end

  def toy_get_family(%__MODULE__{font_face: font}) do
    N.font_face_toy_get_family(font)
  end

  def toy_get_slant(%__MODULE__{font_face: font}) do
    N.font_face_toy_get_slant(font)
  end

  def toy_get_weight(%__MODULE__{font_face: font}) do
    N.font_face_toy_get_weight(font)
  end
end
