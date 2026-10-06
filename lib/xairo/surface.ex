defmodule Xairo.Surface do
  alias Xairo.NIF

  @type t :: reference()

  @spec write_to_png(t(), String.t()) :: :ok | {:error, atom()}
  def write_to_png(surface, filename), do: NIF.surface_write_to_png(surface, filename)

  @spec to_png_stream(t()) :: {:ok, binary()} | {:error, atom()}
  def to_png_stream(surface), do: NIF.surface_write_to_png_stream(surface)
end
