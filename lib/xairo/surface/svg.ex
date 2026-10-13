defmodule Xairo.Surface.Svg do
  @moduledoc """
  Module for working with SVG-backed surfaces, both in memory and on disk.
  """

  alias Xairo.{NIF, Surface}

  @spec create(String.t(), number(), number()) :: {:ok, Surface.t()} | {:error, atom()}
  def create(filename, width, height), do: NIF.svg_surface_create(filename, width / 1, height / 1)

  @spec create_for_stream(number(), number()) :: {:ok, Surface.t()} | {:error, atom()}
  def create_for_stream(width, height),
    do: NIF.svg_surface_create_for_stream(width / 1, height / 1)

  @spec to_binary(Surface.t()) :: {:ok, binary} | {:error, atom()}
  def to_binary(surface), do: NIF.svg_surface_to_binary(surface)
end
