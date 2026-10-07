defmodule Xairo.Context do
  alias Xairo.{NIF, Surface}

  @type t :: reference()

  @spec create(Surface.t()) :: {:ok, t()} | {:error, atom()}
  def create(surface), do: NIF.context_create(surface)
end
