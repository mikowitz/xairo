defmodule Xairo.FontFace do
  @moduledoc """
    Models a font face, defined by a font family, slant, and weight.

    `FontFace` currently supports creating "toy" font faces, as described
    in the [Cairo documentation](https://www.cairographics.org/manual/cairo-text.html)
  """
  defstruct [:font_face]

  @typedoc """
  Elixir model of a font face. Stores a reference to the in-memory
  representation of the font face.
  """
  @type t :: %__MODULE__{
          font_face: reference()
        }
  @type slant :: :normal | :italic | :oblique
  @type weight :: :normal | :bold

  alias Xairo.Native, as: N

  @doc """
  Creates a "toy" font from a font family, a slant value, and a font weight.

  ### Family

  The `family` can be a specific font name, or else a more generic
  font family (serif, sans, monospace, etc.)

  If a font that is not installed is specified, the given value will be stored
  in the font face, but the font's display will fallback to the system's default
  sans-serif font.

  ### Slant

  `slant` is an atom that can be one of the following values

  * `:normal`
  * `:italic`
  * `:oblique`

  ### Weight

  `weight` is an atom that can be one of the following values

  * `:normal`
  * `:bold`
  """
  @spec toy_create(String.t(), slant(), weight()) :: t()
  def toy_create(family, slant, weight) do
    with {:ok, font_face} <- N.font_face_toy_create(family, slant, weight),
         do: %__MODULE__{font_face: font_face}
  end

  @doc """
  Returns the `family` value for the font

      iex> font = FontFace.toy_create("Times New Roman", :italic, :bold)
      iex> FontFace.toy_get_family(font)
      "Times New Roman"

  """
  @spec toy_get_family(t()) :: String.t()
  def toy_get_family(%__MODULE__{font_face: font}) do
    N.font_face_toy_get_family(font)
  end

  @doc """
  Returns the `slant` value for the font

      iex> font = FontFace.toy_create("Times New Roman", :italic, :bold)
      iex> FontFace.toy_get_slant(font)
      :italic

  """
  @spec toy_get_slant(t()) :: slant()
  def toy_get_slant(%__MODULE__{font_face: font}) do
    N.font_face_toy_get_slant(font)
  end

  @doc """
  Returns the `weight` value for the font

      iex> font = FontFace.toy_create("Times New Roman", :italic, :bold)
      iex> FontFace.toy_get_weight(font)
      :bold

  """
  @spec toy_get_weight(t()) :: weight()
  def toy_get_weight(%__MODULE__{font_face: font}) do
    N.font_face_toy_get_weight(font)
  end
end
