defmodule Xairo.SvgSurface do
  defstruct [:surface]

  alias Xairo.Native, as: N

  def new(width, height, path) do
    with {:ok, surface} <- N.svg_surface_new(width / 1, height / 1, path),
         do: %__MODULE__{surface: surface}
  end

  def finish(%__MODULE__{surface: surface} = this) do
    N.svg_surface_finish(surface)
    this
  end

  def document_unit(%__MODULE__{surface: surface}) do
    N.svg_surface_document_unit(surface)
  end

  def set_document_unit(%__MODULE__{surface: surface} = this, unit) do
    N.svg_surface_set_document_unit(surface, unit)
    this
  end
end
