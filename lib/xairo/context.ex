defmodule Xairo.Context do
  @moduledoc """
  Module for handling base Cairo contexts
  """

  alias Xairo.{NIF, Surface}

  @type t :: reference()

  @spec create(Surface.t()) :: {:ok, t()} | {:error, atom()}
  def create(surface), do: NIF.context_create(surface)

  @spec get_target(t()) :: {:ok, Surface.t()} | {:error, atom()}
  def get_target(ctx), do: NIF.context_get_target(ctx)
end
