defmodule Xairo.PdfSurface do
  @moduledoc """
    Models a drawing surface that renders its contents to disk
    in PDF format.
  """
  defstruct [:surface]

  alias Xairo.Native, as: N

  def new(width, height, path) do
    with {:ok, surface} <- N.pdf_surface_new(width / 1, height / 1, path),
         do: %__MODULE__{surface: surface}
  end

  def finish(%__MODULE__{surface: surface} = this) do
    N.pdf_surface_finish(surface)
    this
  end
end
