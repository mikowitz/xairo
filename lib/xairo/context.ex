defmodule Xairo.Context do
  @moduledoc """
  Models a Cairo drawing context that can be instantiated from any
  supported surface type.

  While the context is the underlying Cairo object that handles commands
  relating to drawing onto a surface, the bulk of the Xairo API lives in
  the top-level `Xairo` module.
  """
  defstruct [:context, :surface, :source, :font_face]

  @typedoc """
  The Elixir model of a Cairo context. Stores a reference to the in-memory
  representation of the context, as well as Elixir structs representing the
  surface it was instantiade with, the current color data source, and the current
  font face.
  """
  @type t :: %__MODULE__{
          context: reference(),
          surface: Xairo.surface(),
          source: Xairo.color_source(),
          font_face: Xairo.FontFace.t()
        }

  alias Xairo.{
    ImageSurface,
    PdfSurface,
    PsSurface,
    SvgSurface
  }

  alias Xairo.Native, as: N

  @doc """
  Creates a new context from a `t:Xairo.surface/0`.
  """
  @doc section: :init
  @spec new(Xairo.surface()) :: Xairo.or_error(t())
  def new(%ImageSurface{} = surface) do
    with {:ok, context} <- N.context_new(surface.surface),
         do: %__MODULE__{context: context, surface: surface}
  end

  def new(%PdfSurface{} = surface) do
    with {:ok, context} <- N.context_new_from_pdf_surface(surface.surface),
         do: %__MODULE__{context: context, surface: surface}
  end

  def new(%SvgSurface{} = surface) do
    with {:ok, context} <- N.context_new_from_svg_surface(surface.surface),
         do: %__MODULE__{context: context, surface: surface}
  end

  def new(%PsSurface{} = surface) do
    with {:ok, context} <- N.context_new_from_ps_surface(surface.surface),
         do: %__MODULE__{context: context, surface: surface}
  end
end
