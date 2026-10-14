defmodule Xairo.Context do
  @moduledoc """
  A `Xairo.Context` contains the current state of the rendering device,
  including coordinates of yet to be drawn shapes.

  All drawing with Xairo is always done to a [`Context`](`Xairo.Context`) struct.
  """

  alias Xairo.{NIF, Surface}

  @type t :: reference()

  @doc """
  Creates a new `Xairo.Context` with all graphics state parameters set to
  default values and with `target` as a target surface.

  The target surface should be constructed with a backend-specific function
  such as [`Image.create/3`](`Xairo.Surface.Image.create/3`) or
  [`Svg.create/3`](`Xairo.Surface.Svg.create/3`).
  """
  @spec create(Surface.t()) :: {:ok, t()} | {:error, atom()}
  def create(surface), do: NIF.context_create(surface)

  @doc """
  Gets the target surface for `context` as passed to `create/1`.
  """
  @spec get_target(t()) :: {:ok, Surface.t()} | {:error, atom()}
  def get_target(context), do: NIF.context_get_target(context)
end
