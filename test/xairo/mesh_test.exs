defmodule Xairo.MeshTest do
  use ExUnit.Case, async: true

  alias Xairo.{Mesh, Point, Rgba}

  describe "new/0" do
    test "returns a mesh struct" do
      mesh = Mesh.new()

      assert is_struct(mesh, Mesh)
    end
  end

  describe "patch_count/1" do
    test "returns 0 for a new mesh" do
      mesh = Mesh.new()

      assert Mesh.patch_count(mesh) == 0
    end

    test "returns an error if a patch contains no edges" do
      mesh =
        Mesh.new()
        |> Mesh.begin_patch()
        |> Mesh.end_patch()

      assert Mesh.patch_count(mesh) == {:error, :invalid_mesh_construction}
    end

    test "returns the number of patches" do
      mesh =
        Mesh.new()
        |> Mesh.begin_patch()
        |> Mesh.move_to(Point.new(0, 0))
        |> Mesh.line_to(Point.new(100, 50))
        |> Mesh.line_to(Point.new(50, 100))
        |> Mesh.line_to(Point.new(0, 0))
        |> Mesh.end_patch()

      assert Mesh.patch_count(mesh) == 1

      mesh =
        mesh
        |> Mesh.begin_patch()
        |> Mesh.move_to(Point.new(10, 10))
        |> Mesh.curve_to(Point.new(20, 20), Point.new(50, -10), Point.new(80, 30))
        |> Mesh.curve_to(Point.new(80, 20), Point.new(90, 30), Point.new(100, 100))
        |> Mesh.curve_to(Point.new(20, 100), Point.new(10, 130), Point.new(-10, 80))
        |> Mesh.curve_to(Point.new(0, 70), Point.new(10, 50), Point.new(-10, -10))
        |> Mesh.end_patch()

      assert Mesh.patch_count(mesh) == 2
    end
  end

  describe "set_control_point/3" do
    test "sets an additional control point for the given corner in the current patch" do
      mesh =
        Mesh.new()
        |> Mesh.begin_patch()
        |> Mesh.move_to(Point.new(0, 0))
        |> Mesh.line_to(Point.new(100, 50))
        |> Mesh.line_to(Point.new(50, 100))
        |> Mesh.line_to(Point.new(0, 0))
        |> Mesh.set_control_point(0, Point.new(50, 50))
        |> Mesh.end_patch()

      assert Mesh.control_point(mesh, 0, 0) == Point.new(50.0, 50.0)
    end

    test "errors when the corner does not exist" do
      mesh =
        Mesh.new()
        |> Mesh.begin_patch()
        |> Mesh.move_to(Point.new(0, 0))
        |> Mesh.line_to(Point.new(100, 50))
        |> Mesh.line_to(Point.new(50, 100))
        |> Mesh.line_to(Point.new(0, 0))
        |> Mesh.set_control_point(0, Point.new(50, 50))
        |> Mesh.end_patch()

      assert Mesh.control_point(mesh, 0, 4) == {:error, :invalid_index}
    end

    test "errors when the patch does not exist" do
      mesh =
        Mesh.new()
        |> Mesh.begin_patch()
        |> Mesh.move_to(Point.new(0, 0))
        |> Mesh.line_to(Point.new(100, 50))
        |> Mesh.line_to(Point.new(50, 100))
        |> Mesh.line_to(Point.new(0, 0))
        |> Mesh.set_control_point(0, Point.new(50, 50))
        |> Mesh.end_patch()

      assert Mesh.control_point(mesh, 1, 0) == {:error, :invalid_index}
    end
  end

  describe "set_corner_color/5" do
    test "sets a color at the given corner for the current patch" do
      mesh =
        Mesh.new()
        |> Mesh.begin_patch()
        |> Mesh.move_to(Point.new(0, 0))
        |> Mesh.line_to(Point.new(100, 50))
        |> Mesh.line_to(Point.new(50, 100))
        |> Mesh.line_to(Point.new(0, 0))
        |> Mesh.set_corner_color(0, Rgba.new(1, 0, 0, 0.5))
        |> Mesh.end_patch()

      assert Mesh.corner_color_rgba(mesh, 0, 0) == Rgba.new(1.0, 0.0, 0.0, 0.5)
    end
  end

  describe "corner_color_rgba/3" do
    test "returns transparent black if no color has been set" do
      mesh =
        Mesh.new()
        |> Mesh.begin_patch()
        |> Mesh.move_to(Point.new(0, 0))
        |> Mesh.line_to(Point.new(100, 50))
        |> Mesh.line_to(Point.new(50, 100))
        |> Mesh.line_to(Point.new(0, 0))
        |> Mesh.set_corner_color(0, Rgba.new(1, 0, 0))
        |> Mesh.end_patch()

      assert Mesh.corner_color_rgba(mesh, 0, 3) == Rgba.new(0.0, 0.0, 0.0, 0.0)
    end

    test "returns an error if an invalid corner is given" do
      mesh =
        Mesh.new()
        |> Mesh.begin_patch()
        |> Mesh.move_to(Point.new(0, 0))
        |> Mesh.line_to(Point.new(100, 50))
        |> Mesh.line_to(Point.new(50, 100))
        |> Mesh.line_to(Point.new(0, 0))
        |> Mesh.set_corner_color(0, Rgba.new(1, 0, 0))
        |> Mesh.end_patch()

      assert Mesh.corner_color_rgba(mesh, 0, 4) == {:error, :invalid_index}
    end

    test "returns an error if an invalid patch is given" do
      mesh =
        Mesh.new()
        |> Mesh.begin_patch()
        |> Mesh.move_to(Point.new(0, 0))
        |> Mesh.line_to(Point.new(100, 50))
        |> Mesh.line_to(Point.new(50, 100))
        |> Mesh.line_to(Point.new(0, 0))
        |> Mesh.set_corner_color(0, Rgba.new(1, 0, 0))
        |> Mesh.end_patch()

      assert Mesh.corner_color_rgba(mesh, 1, 0) == {:error, :invalid_index}
    end
  end

  describe "path/2" do
    test "returns the path for the given patch" do
      mesh =
        Mesh.new()
        |> Mesh.begin_patch()
        |> Mesh.move_to(Point.new(0, 0))
        |> Mesh.line_to(Point.new(100, 50))
        |> Mesh.line_to(Point.new(50, 100))
        |> Mesh.line_to(Point.new(0, 0))
        |> Mesh.end_patch()

      path = Mesh.path(mesh, 0)

      assert is_struct(path, Xairo.Path)

      assert Enum.reduce(path, [], fn segment, acc ->
               command =
                 case segment do
                   :close_path -> :close_path
                   segment -> elem(segment, 0)
                 end

               acc ++ [command]
             end) == [:move_to, :curve_to, :curve_to, :curve_to, :curve_to]
    end
  end

  test "returns an error if called with an invalid patch" do
    mesh =
      Mesh.new()
      |> Mesh.begin_patch()
      |> Mesh.move_to(Point.new(0, 0))
      |> Mesh.line_to(Point.new(100, 50))
      |> Mesh.line_to(Point.new(50, 100))
      |> Mesh.line_to(Point.new(0, 0))
      |> Mesh.end_patch()

    assert Mesh.path(mesh, 1) == {:error, :invalid_index}
  end
end
