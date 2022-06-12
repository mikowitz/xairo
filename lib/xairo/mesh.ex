defmodule Xairo.Mesh do
  @moduledoc """
  Models a tensor-product patch mesh that can be set as a surface's color source.

  A mesh can contain any number of patches.

  At the most basic level, a patch is defined by 4 Bézier curves that describe
  the sides of the patch, joined at 4 corners. Each corner is assigned an RGBA color
  (if no color is set, it defaults to fully transparent black), and each corner can
  have an optional additional control point set to determine how the colors blend between
  the corners.

  A triangular patch can be created by only defining 3 sides.

  In addition to Bézier curves, the sides can also be defined by simple lines.

  For a more detailed understanding of how these patches work, see the
  [cairo definition](https://www.cairographics.org/manual/cairo-cairo-pattern-t.html#cairo-pattern-create-mesh).

  The following diagram (taken from the documentation above), shows the basic shape of a mesh patch,
  and will be a useful reference in explaining how to construct a `Xairo.Mesh` struct

  ```
        C1        Side 1           C2
         +-------------------------+
         |                         |
         |    P1             P2    |
         |                         |
  Side 0 |                         | Side 2
         |                         |
         |                         |
         |    P0             P3    |
         |                         |
         +-------------------------+
       C0          Side 3          C3
  ```

  **NB** in this diagram the starting point of the patch is C0 in the bottom left, but
  the patch can be oriented starting from any corner. In the example below, for
  instance, C0 is at {0,0} in the top left.

  ## Example

  ### Creating the mesh struct

  Create a new Mesh struct, begin a new patch, and sets the start point (C0 in the diagram above)

  ```
  mesh = Mesh.new()
  |> Mesh.begin_patch()
  |> Mesh.move_to(Point.new(0,0))
  ```

  draw the 4 sides of the patch

  ```
  mesh
  |> Mesh.curve_to({30, 20}, {80, -10}, {100, 0}) # draws Side 0 as a curve from C0 to C1
  |> Mesh.line_to({100, 100})                     # draws Side 1 as a straight line from C1 to C2
  |> Mesh.line_to({0, 100})                       # draws Side 2 as a straight line from C2 to C3
  |> Mesh.curve_to({-20, 80}, {30, 30}, {0, 0})   # draws Side 3 as a curve from C3 to C0
  ```

  set colors for each of the four corners

  ```
  mesh
  |> Mesh.set_corner_color(0, RGBA.new(1, 0, 0)) # sets the color at C0 to red
  |> Mesh.set_corner_color(1, RGBA.new(0, 1, 0)) # sets the color at C1 to green
  |> Mesh.set_corner_color(2, RGBA.new(1, 0, 1)) # sets the color at C2 to blue
  |> Mesh.set_corner_color(3, RGBA.new(0, 1, 1)) # sets the color at C3 to cyan
  ```

  set control points for corners C0 and C2

  ```
  mesh
  |> Mesh.set_control_point(0, Point.new(20, 20))
  |> Mesh.set_control_point(2, Point.new(50, 50))
  ```

  finalize the patch

  ```
  Mesh.end_patch(mesh)
  ```

  and set the mesh as the color source for a context

  ```
  Context.set_source(context, mesh)
  ```
  """
  defstruct [:pattern]

  @typedoc """
  The Elixir model of a mesh pattern. Stores a reference to the in-memory
  native representation of the mesh.
  """
  @type t :: %__MODULE__{
          pattern: reference()
        }

  alias Xairo.Native, as: N
  alias Xairo.{Path, Point, Rgba}

  @doc """
  Initializes a new Mesh pattern.
  """
  @spec new() :: t()
  def new do
    %__MODULE__{
      pattern: N.mesh_new()
    }
  end

  @doc """
  Returns the number of complete patches currently defined for the mesh.

      iex> mesh = Mesh.new()
      iex> Mesh.patch_count(mesh)
      0

  """
  @spec patch_count(t()) :: Xairo.or_error(integer)
  def patch_count(%__MODULE__{pattern: mesh}) do
    with {:ok, count} <- N.mesh_patch_count(mesh), do: count
  end

  @doc """
  Begins a new patch for the mesh.

  ## Examples

  Returns the `Mesh` struct to allow for easier chaining.

      iex> mesh = Mesh.new()
      ...> |> Mesh.begin_patch()
      iex> is_struct(mesh, Mesh)
      true

  If `begin_patch/1` is called when a patch is already
  open, it will return an error tuple

      iex> Mesh.new()
      ...> |> Mesh.begin_patch()
      ...> |> Mesh.begin_patch()
      {:error, :invalid_mesh_construction}

  """
  @spec begin_patch(t()) :: Xairo.or_error(t())
  def begin_patch(%__MODULE__{pattern: pattern} = mesh) do
    with {:ok, _} <- N.mesh_begin_patch(pattern), do: mesh
  end

  @doc """
  Ends the currently open patch on the mesh.

  ## Examples

  Returns the `Mesh` struct to allow for easier chaining.

      iex> mesh = Mesh.new()
      ...> |> Mesh.begin_patch()
      ...> |> Mesh.move_to(Point.new(10, 10))
      ...> |> Mesh.end_patch()
      iex> is_struct(mesh, Mesh)
      true

  If `end_patch/1` is called when no patch is in progress,
  it will return an error tuple

      iex> Mesh.new()
      ...> |> Mesh.end_patch()
      {:error, :invalid_mesh_construction}

  """
  @spec end_patch(t()) :: Xairo.or_error(t())
  def end_patch(%__MODULE__{pattern: pattern} = mesh) do
    with {:ok, _} <- N.mesh_end_patch(pattern), do: mesh
  end

  @doc """
  Moves the current point of the active patch to the given point.

  This is used when first defining a patch to set the initial corner position.
  Afterwards `line_to/2` and `curve_to/4` are used to define the patch boundaries.
  """
  @spec move_to(t(), Point.t()) :: t()
  def move_to(%__MODULE__{pattern: pattern} = mesh, %Point{} = point) do
    N.mesh_move_to(pattern, point)
    mesh
  end

  @doc """
  Creates an edge for the currently active patch as a straight line.
  """
  @spec line_to(t(), Point.t()) :: t()
  def line_to(%__MODULE__{pattern: pattern} = mesh, %Point{} = point) do
    N.mesh_line_to(pattern, point)
    mesh
  end

  @doc """
  Creates an edge for the currently active patch as a Bézier curve.
  """
  @spec curve_to(t(), Point.t(), Point.t(), Point.t()) :: t()
  def curve_to(
        %__MODULE__{pattern: pattern} = mesh,
        %Point{} = point1,
        %Point{} = point2,
        %Point{} = point3
      ) do
    N.mesh_curve_to(pattern, point1, point2, point3)
    mesh
  end

  @doc """
  Sets an additional control point for the specified corner of the active patch
  to modify how color blending between the corners takes place.

  Will return an error tuple if there is no active patch or the current patch does
  not have a edge defined leading to the corner at the given index.
  """
  @spec set_control_point(t(), integer(), Point.t()) :: Xairo.or_error(t())
  def set_control_point(%__MODULE__{pattern: pattern} = mesh, corner, %Point{} = point) do
    with {:ok, _} <- N.mesh_set_control_point(pattern, corner, point), do: mesh
  end

  @doc """
  Returns the control point for the mesh at the specified patch and corner indices.

  Returns an error tuple if the patch or corner index points to an nonexistent patch
  or corner.
  """
  @spec control_point(t(), integer(), integer()) :: Xairo.or_error(t())
  def control_point(%__MODULE__{pattern: mesh}, patch, corner) do
    with {:ok, point} <- N.mesh_control_point(mesh, patch, corner), do: point
  end

  @doc """
  Sets the color for the given corner of the active patch.
  """
  @spec set_corner_color(t(), integer(), Rgba.t()) :: Xairo.or_error(t())
  def set_corner_color(%__MODULE__{pattern: pattern} = mesh, corner, %Rgba{} = rgba) do
    with {:ok, _} <- N.mesh_set_corner_color(pattern, corner, rgba), do: mesh
  end

  @doc """
  Returns the `Rgba` value for the mesh at the specified patch and corner indices.

  Returns an error tuple if the patch or corner index points to an nonexistent patch
  or corner.
  """
  @spec corner_color_rgba(t(), integer(), integer()) :: Xairo.or_error(Rgba.t())
  def corner_color_rgba(%__MODULE__{pattern: mesh}, path, corner) do
    with {:ok, rgba} <- N.mesh_corner_color_rgba(mesh, path, corner), do: rgba
  end

  @doc """
  Returns a `Path` struct representing the edges of the mesh's patch at the given index.

  Will return an error tuple if no patch exists at the given index.
  """
  @spec path(t(), integer()) :: Xairo.or_error(Path.t())
  def path(%__MODULE__{pattern: mesh}, patch) do
    with {:ok, path} <- N.mesh_path(mesh, patch), do: Path.from(path)
  end
end
