defmodule Xairo.Surface.Svg do
  @moduledoc """
  Module for working with SVG-backed surfaces, both in memory and on disk.
  """

  alias Xairo.{NIF, Surface}

  @doc """
  Creates a SVG surface of the specified size in points to be written to `filename`.

  The SVG surface backend recognizes the following MIME types for the data
  attached to a surface (see cairo_surface_set_mime_data()) when it is used as
  a source pattern for drawing on this surface: CAIRO_MIME_TYPE_JPEG,
  CAIRO_MIME_TYPE_PNG, CAIRO_MIME_TYPE_URI. If any of them is specified, the
  SVG backend emits a href with the content of MIME data instead of a surface
  snapshot (PNG, Base64-encoded) in the corresponding image tag.
  """
  @spec create(String.t(), number(), number()) :: {:ok, Surface.t()} | {:error, atom()}
  def create(filename, width, height), do: NIF.svg_surface_create(filename, width / 1, height / 1)

  @doc """
  Creates a SVG surface of the specified size in points to be written
  incrementally to memory.
  """
  @spec create_for_stream(number(), number()) :: {:ok, Surface.t()} | {:error, atom()}
  def create_for_stream(width, height),
    do: NIF.svg_surface_create_for_stream(width / 1, height / 1)

  @doc """
  Retrieves the stream data for an `Xairo.Surface.Svg` surface created via `create_for_stream/2`.

  Will return an error if called on a disk-backed `Xairo.Surface.Svg` surface.
  """
  @spec to_binary(Surface.t()) :: {:ok, binary} | {:error, atom()}
  def to_binary(surface), do: NIF.svg_surface_to_binary(surface)
end
