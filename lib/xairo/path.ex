defmodule Xairo.Path do
  @moduledoc """
  Models a read-only representation of a path defined on a drawing surface
  or mesh color source.

  The struct stores two values:

  * `path` - a `t:reference/0` pointing to the Rust (and underlying C)
    representation of the path in memory
  * `segments` - a list of path segments representing the current
    path on the drawing surface at the time the path is queried.

  ### Path Segments

  Path segments take one of four forms:

  * `{:move_to, %Point{}}` - the current point moving to the attached point
  * `{:line_to, %Point{}}` - a line drawn to the attached point
  * `{:curve_to, %Point{}, %Point{}, %Point{}}` - a Bézier curve drawn with the
  three attached control points
  * `:close_path` - a line from the current point to the origin
  point of the path

  ### Enumerable

  The `Xairo.Path` struct implements the `Enumerable` protocol, allowing all `Enum`
  functions to be called directly on the struct as a shorthand, but delegating
  through to its `segments` field.

  """

  defstruct [:path, :segments]

  alias Xairo.Point

  @type segment ::
          {:move_to, Point.t()}
          | {:line_to, Point.t()}
          | {:curve_to, Point.t(), Point.t(), Point.t()}
          | :close_path

  @type t :: %__MODULE__{
          segments: [segment()]
        }

  @doc """
  Returns a `Xairo.Path` struct from a `t:reference/0` that points to the
  in-memory representation of the path.

  Calls into Rust to calculate the path segments and cache them in the struct
  to avoid having to recalculate the segments on each call to access them.

  The path reference is stored for use with the `Xairo.append_path/2`
  function, so that the Rust representation of the path does not need to be
  recalculated from the Elixir segments when this function is called. Because
  a `Xairo.Path` represents a read-only version of the path, we don't have
  to worry about the in-memory representation getting out of sync with
  the segment tuples in Elixir.

  #### Caveat

  It _is_, strictly, possible to get the Elixir representation out of sync
  by appending valid-shaped segment tuples on to an existing `Xairo.Path`,
  but as, at the moment, those are not ever synced back into Rust, they
  will not be represented in a call to `Xairo.Contex.append_path/2`.

  """
  @spec from(reference()) :: __MODULE__.t()
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
    {:ok, size, fn _ -> segments end}
  end

  def reduce(%Path{segments: segments}, acc, fun) do
    Enumerable.List.reduce(segments, acc, fun)
  end
end
