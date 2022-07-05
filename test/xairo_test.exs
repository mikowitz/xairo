defmodule XairoTest do
  use ExUnit.Case
  import Xairo.Test.Support.ImageHelpers

  doctest Xairo

  alias Xairo.{
    Image,
    LinearGradient,
    Mesh,
    Point,
    RadialGradient,
    Rgba,
    SolidPattern,
    SurfacePattern,
    Vector
  }

  import Xairo

  describe "arc/5" do
    test "draws a clockwise arc using the given coordinates" do
      Image.new("arc.png", 100, 100)
      |> set_source(Rgba.new(0, 0, 0))
      |> arc(Point.new(50, 50), 25, 0, 1.5)
      |> stroke()
      |> assert_image()
    end
  end

  describe "arc_negative" do
    test "draws a counter-clockwise arc using the given coordinates" do
      Image.new("arc_negative.png", 100, 100)
      |> set_source(Rgba.new(0, 0, 0))
      |> arc_negative(Point.new(50, 50), 25, 0, 1.5)
      |> stroke()
      |> assert_image()
    end
  end

  describe "curve_to/4 and rel_curve_to/4" do
    test "draws a curve with absolute or relative coordinates" do
      Image.new("curve_to.png", 100, 100)
      |> set_source(Rgba.new(0, 0, 1))
      |> curve_to(Point.new(10, 30), Point.new(50, 5), Point.new(80, 20))
      |> move_to(Point.new(10, 50))
      |> rel_curve_to(Vector.new(15, -5), Vector.new(40, 20), Vector.new(60, -20))
      |> stroke()
      |> assert_image()
    end
  end

  describe "line_to/2 and rel_line_to/2" do
    test "draws lines to absolute or relative coordinates from the origin" do
      Image.new("line_to.png", 100, 100)
      |> set_source(Rgba.new(1, 1, 0))
      |> move_to(Point.new(10, 10))
      |> line_to(Point.new(50, 60))
      |> rel_line_to(Vector.new(-20, -10))
      |> stroke()
      |> assert_image()
    end
  end

  describe "rectangle/4" do
    test "draws a rectangle from the given coordinate and dimensions" do
      Image.new("rectangle.png", 100, 100)
      |> set_source(Rgba.new(0, 1, 1))
      |> paint_with_alpha(0.2)
      |> set_source(Rgba.new(0, 0, 0))
      |> rectangle(Point.new(10, 10), 60, 40)
      |> stroke_preserve()
      |> set_source(Rgba.new(0, 0, 1, 0.4))
      |> fill()
      |> assert_image()
    end
  end

  describe "close_path/1" do
    test "connects the current point to the point of the most recent move_to" do
      Image.new("close_path.png", 100, 100)
      |> set_source(Rgba.new(1, 0, 1))
      |> move_to(Point.new(10, 10))
      |> line_to(Point.new(40, 15))
      |> line_to(Point.new(60, 40))
      |> rel_move_to(Vector.new(-20, -10))
      |> line_to(Point.new(5, 80))
      |> line_to(Point.new(20, 90))
      |> close_path()
      |> stroke()
      |> assert_image()
    end
  end

  describe "new_path/1" do
    test "begins a new path and removes any existing path components" do
      Image.new("new_path.png", 100, 100)
      |> set_source(Rgba.new(1, 0, 1))
      |> move_to(Point.new(10, 10))
      |> line_to(Point.new(15, 80))
      |> new_path()
      |> arc(Point.new(60, 40), 20, 0, 4)
      |> stroke()
      |> assert_image()
    end
  end

  describe "new_sub_path/1" do
    test "begins a new path but retains existing path components" do
      Image.new("new_sub_path.png", 100, 100)
      |> set_source(Rgba.new(1, 0, 1))
      |> move_to(Point.new(10, 10))
      |> line_to(Point.new(15, 80))
      |> new_sub_path()
      |> arc(Point.new(60, 40), 20, 0, 4)
      |> stroke()
      |> assert_image()
    end
  end

  describe "copy_path/1" do
    test "returns a Path struct" do
      image = Image.new("test.png", 100, 100)

      path = copy_path(image)

      assert is_struct(path, Xairo.Path)
    end
  end

  describe "copy_path_flat/1" do
    test "returns a Path struct" do
      image = Image.new("test.png", 100, 100)

      path = copy_path_flat(image)

      assert is_struct(path, Xairo.Path)
    end
  end

  describe "append_path/2" do
    test "appends the given path to the context's path" do
      image =
        Image.new("before_append_path.png", 100, 100)
        |> set_source(Rgba.new(0, 1, 0))
        |> move_to(Point.new(10, 10))
        |> line_to(Point.new(50, 50))
        |> line_to(Point.new(20, 70))
        |> close_path()

      path = copy_path(image)

      image = new_path(image)

      assert_image(image)

      image =
        image
        |> append_path(path)
        |> fill()

      assert_image(image, "after_append_path.png")
    end

    test "copy_flat_path copies the path, replacing curves with approximations of straight lines" do
      image =
        Image.new("copy_path_flat.png", 100, 100)
        |> set_source(Rgba.new(0, 0, 0))
        |> paint()
        |> set_source(Rgba.new(1, 1, 1))
        |> arc(Point.new(50, 50), 40, 0, 3.5)
        |> set_tolerance(10)

      path = copy_path_flat(image)

      image
      |> set_tolerance(0.1)
      |> stroke()
      |> append_path(path)
      |> stroke()
      |> assert_image()
    end
  end

  describe "set_source/2" do
    test "sets the source color to an RGBA-defined color" do
      Image.new("set_source_rgba.png", 100, 100)
      |> set_source(Rgba.new(0, 0.5, 1.0, 0.35))
      |> paint()
      |> assert_image()
    end

    test "sets the `source` field of the context to a SolidPattern`" do
      image =
        Image.new("test.png", 100, 100)
        |> set_source(Rgba.new(0.3, 0.4, 0.5, 0.6))

      assert is_struct(image.context.source, SolidPattern)

      assert SolidPattern.rgba(image.context.source) == Rgba.new(0.3, 0.4, 0.5, 0.6)
    end

    test "sets a linear gradient as the color source for an image" do
      image = Image.new("linear_gradient.png", 100, 100)

      lg =
        LinearGradient.new(Point.new(0, 0), Point.new(100, 50))
        |> LinearGradient.add_color_stop(0.2, Rgba.new(1, 0, 0))
        |> LinearGradient.add_color_stop(0.8, Rgba.new(0.5, 0, 1))

      image =
        image
        |> set_source(lg)
        |> paint()

      assert_image(image)

      assert source(image) == lg
    end

    test "sets a radial gradient as the color source for an image" do
      image = Image.new("radial_gradient.png", 100, 100)

      rg =
        RadialGradient.new(Point.new(50, 50), 10, Point.new(50, 50), 50)
        |> RadialGradient.add_color_stop(0.2, Rgba.new(1, 0, 0))
        |> RadialGradient.add_color_stop(1, Rgba.new(0.5, 0, 1))

      image =
        image
        |> set_source(rg)
        |> paint()

      assert_image(image)

      assert source(image) == rg
    end

    test "sets a solid pattern as the color source for an image" do
      image = Image.new("solid_pattern.png", 100, 100)

      sp = SolidPattern.from_rgba(Rgba.new(0.3, 0.5, 1.0))

      image =
        image
        |> set_source(sp)
        |> paint()

      assert_image(image)

      assert source(image) == sp
    end

    test "sets a surface pattern as the color source for an image" do
      image = Image.new("surface_pattern.png", 100, 100)

      pattern =
        Image.new("pattern.png", 100, 100)
        |> set_source(Rgba.new(1, 1, 1))
        |> paint()
        |> set_source(Rgba.new(1, 0.5, 0))
        |> move_to(Point.new(0, 0))
        |> line_to(Point.new(100, 100))
        |> stroke()
        |> set_source(Rgba.new(0, 1, 1, 0.5))
        |> move_to(Point.new(100, 0))
        |> line_to(Point.new(0, 100))
        |> stroke()

      sp = SurfacePattern.create(pattern.surface)

      image =
        image
        |> set_source(sp)
        |> rectangle(Point.new(20, 20), 60, 70)
        |> fill()

      assert_image(image)

      assert source(image) == sp
    end

    test "sets a mesh as the color source for an image" do
      image = Image.new("mesh.png", 100, 100)

      mesh =
        Mesh.new()
        |> Mesh.begin_patch()
        |> Mesh.move_to(Point.new(10, 10))
        |> Mesh.curve_to(Point.new(20, 20), Point.new(50, -10), Point.new(130, -30))
        |> Mesh.curve_to(Point.new(80, 20), Point.new(90, 30), Point.new(100, 100))
        |> Mesh.curve_to(Point.new(20, 100), Point.new(10, 130), Point.new(-10, 80))
        |> Mesh.curve_to(Point.new(0, 70), Point.new(10, 50), Point.new(-10, -10))
        |> Mesh.set_corner_color(0, Rgba.new(1, 0, 0))
        |> Mesh.set_corner_color(1, Rgba.new(1, 0.5, 0))
        |> Mesh.set_corner_color(2, Rgba.new(1, 1, 0))
        |> Mesh.set_corner_color(3, Rgba.new(0.5, 1, 0))
        |> Mesh.end_patch()
        |> Mesh.begin_patch()
        |> Mesh.move_to(Point.new(0, 0))
        |> Mesh.line_to(Point.new(90, 30))
        |> Mesh.line_to(Point.new(30, 90))
        |> Mesh.line_to(Point.new(0, 0))
        |> Mesh.set_corner_color(0, Rgba.new(0, 1, 0, 0.5))
        |> Mesh.set_corner_color(1, Rgba.new(0, 1, 0.5, 0.5))
        |> Mesh.set_corner_color(2, Rgba.new(0, 0.5, 1, 0.5))
        |> Mesh.end_patch()

      image =
        image
        |> set_source(Rgba.new(1, 1, 1))
        |> paint()
        |> set_source(mesh)
        |> rectangle(Point.new(10, 20), 70, 50)
        |> fill()

      assert_image(image)

      assert is_struct(image.context.source, Mesh)
    end

    test "sets a surface as the color source at the given coordinates" do
      image = Image.new("set_source_surface.png", 100, 100)

      surface =
        Image.new("surface.png", 100, 100)
        |> set_source(Rgba.new(1, 1, 1))
        |> paint()
        |> set_source(Rgba.new(0.5, 0, 1))
        |> rectangle(Point.new(20, 30), 40, 50)
        |> fill_preserve()
        |> set_source(Rgba.new(0, 0, 0))
        |> stroke()
        |> move_to(Point.new(80, 10))
        |> line_to(Point.new(10, 70))
        |> stroke()

      image
      |> set_source(Rgba.new(0, 0, 0))
      |> paint()
      |> set_source(surface, Point.new(20, 10))
      |> set_line_width(20)
      |> move_to(Point.new(0, 0))
      |> line_to(Point.new(100, 100))
      |> stroke()
      |> assert_image()
    end
  end

  describe "dashes/3" do
    test "sets the dash pattern for the context" do
      Image.new("dashes.png", 100, 100)
      |> set_source(Rgba.new(0.5, 0, 1))
      |> paint()
      |> set_source(Rgba.new(0, 0, 0))
      |> set_dash([5, 2], 0)
      |> move_to(Point.new(10, 10))
      |> line_to(Point.new(90, 90))
      |> line_to(Point.new(90, 10))
      |> close_path()
      |> stroke()
      |> move_to(Point.new(10, 90))
      |> line_to(Point.new(80, 90))
      |> set_dash([5, 2, 3], 1)
      |> stroke()
      |> assert_image()
    end
  end

  describe "dash_count/1" do
    test "returns the number of dash components in the pattern" do
      image = Image.new("test.png", 100, 100)

      assert dash_count(image) == 0

      image = set_dash(image, [5, 2, 3], 1)

      assert dash_count(image) == 3
    end
  end

  describe "dash/1" do
    test "returns the list of dash components and offset" do
      image = Image.new("test.png", 100, 100)

      assert dash(image) == {[], 0.0}

      image = set_dash(image, [5, 2, 3], 1)

      assert dash(image) == {[5.0, 2.0, 3.0], 1.0}
    end
  end

  describe "dash_dashes/1" do
    test "returns just the list of dash components" do
      image = Image.new("test.png", 100, 100)

      assert dash_dashes(image) == []

      image = set_dash(image, [5, 2, 3], 1)

      assert dash_dashes(image) == [5.0, 2.0, 3.0]
    end
  end

  describe "dash_offset/1" do
    test "returns just the dash offset" do
      image = Image.new("test.png", 100, 100)

      assert dash_offset(image) == 0.0

      image = set_dash(image, [5, 2, 3], 1)

      assert dash_offset(image) == 1.0
    end
  end
end
