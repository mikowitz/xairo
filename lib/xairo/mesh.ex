defmodule Xairo.Mesh do
  @moduledoc """
    Models a tensor-product patch mesh that can be set as a drawing surface's
    color source.
  """
  defstruct [:pattern]

  alias Xairo.Native, as: N
  alias Xairo.Path

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

  def move_to(%__MODULE__{pattern: mesh} = this, x, y) do
    N.mesh_move_to(mesh, x / 1, y / 1)
    this
  end

  def line_to(%__MODULE__{pattern: mesh} = this, x, y) do
    N.mesh_line_to(mesh, x / 1, y / 1)
    this
  end

  def curve_to(%__MODULE__{pattern: mesh} = this, x1, y1, x2, y2, x3, y3) do
    N.mesh_curve_to(mesh, x1 / 1, y1 / 1, x2 / 1, y2 / 1, x3 / 1, y3 / 1)
    this
  end

  def set_control_point(%__MODULE__{pattern: mesh} = this, corner, x, y) do
    with {:ok, _} <- N.mesh_set_control_point(mesh, corner, x / 1, y / 1), do: this
  end

  def control_point(%__MODULE__{pattern: mesh}, patch, corner) do
    with {:ok, point} <- N.mesh_control_point(mesh, patch, corner), do: point
  end

  def set_corner_color_rgb(%__MODULE__{pattern: mesh} = this, corner, red, green, blue) do
    with {:ok, _} <- N.mesh_set_corner_color_rgb(mesh, corner, red / 1, green / 1, blue / 1),
         do: this
  end

  def set_corner_color_rgba(%__MODULE__{pattern: mesh} = this, corner, red, green, blue, alpha) do
    with {:ok, _} <-
           N.mesh_set_corner_color_rgba(mesh, corner, red / 1, green / 1, blue / 1, alpha / 1),
         do: this
  end

  def corner_color_rgba(%__MODULE__{pattern: mesh}, path, corner) do
    with {:ok, rgba} <- N.mesh_corner_color_rgba(mesh, path, corner), do: rgba
  end

  def path(%__MODULE__{pattern: mesh}, patch) do
    with {:ok, path} <- N.mesh_path(mesh, patch), do: Path.from(path)
  end
end
