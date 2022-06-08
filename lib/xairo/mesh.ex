defmodule Xairo.Mesh do
  @moduledoc """
    Models a tensor-product patch mesh that can be set as a drawing surface's
    color source.
  """
  defstruct [:pattern]

  alias Xairo.Native, as: N
  alias Xairo.{Path, Point, Rgba}

  def new do
    %__MODULE__{
      pattern: N.mesh_new()
    }
  end

  def patch_count(%__MODULE__{pattern: mesh}) do
    with {:ok, count} <- N.mesh_patch_count(mesh), do: count
  end

  def begin_patch(%__MODULE__{pattern: mesh} = this) do
    N.mesh_begin_patch(mesh)
    this
  end

  def end_patch(%__MODULE__{pattern: mesh} = this) do
    N.mesh_end_patch(mesh)
    this
  end

  def move_to(%__MODULE__{pattern: mesh} = this, %Point{} = point) do
    N.mesh_move_to(mesh, point)
    this
  end

  def line_to(%__MODULE__{pattern: mesh} = this, %Point{} = point) do
    N.mesh_line_to(mesh, point)
    this
  end

  def curve_to(
        %__MODULE__{pattern: mesh} = this,
        %Point{} = point1,
        %Point{} = point2,
        %Point{} = point3
      ) do
    N.mesh_curve_to(mesh, point1, point2, point3)
    this
  end

  def set_control_point(%__MODULE__{pattern: mesh} = this, corner, %Point{} = point) do
    with {:ok, _} <- N.mesh_set_control_point(mesh, corner, point), do: this
  end

  def control_point(%__MODULE__{pattern: mesh}, patch, corner) do
    with {:ok, point} <- N.mesh_control_point(mesh, patch, corner), do: point
  end

  def set_corner_color(%__MODULE__{pattern: mesh} = this, corner, %Rgba{} = rgba) do
    with {:ok, _} <- N.mesh_set_corner_color(mesh, corner, rgba), do: this
  end

  def corner_color_rgba(%__MODULE__{pattern: mesh}, path, corner) do
    with {:ok, rgba} <- N.mesh_corner_color_rgba(mesh, path, corner), do: rgba
  end

  def path(%__MODULE__{pattern: mesh}, patch) do
    with {:ok, path} <- N.mesh_path(mesh, patch), do: Path.from(path)
  end
end
