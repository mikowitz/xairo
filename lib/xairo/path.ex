defmodule Xairo.Path do
  @moduledoc """
    Models a read-only representation of a path defined on a drawing surface
    or mesh color source.
  """

  defstruct [:path, :segments]

  def from(path) when is_reference(path) do
    %__MODULE__{path: path, segments: Xairo.Native.path_iter(path)}
  end
end

defimpl Enumerable, for: Xairo.Path do
  alias Xairo.Path

  def count(%Path{segments: segments}) do
    {:ok, length(segments)}
  end

  def member?(%Path{segments: segments}, segment) do
    {:ok, segment in segments}
  end

  def slice(%Path{segments: segments}) do
    size = length(segments)
    {:ok, size, &Enumerable.List.slice(segments, &1, &2, size)}
  end

  def reduce(%Path{segments: segments}, acc, fun) do
    Enumerable.List.reduce(segments, acc, fun)
  end
end
