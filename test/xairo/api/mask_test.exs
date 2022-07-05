defmodule Xairo.Api.MaskTest do
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
    SurfacePattern
  }

  import Xairo

  describe "mask/2" do
    test "applies an alpha mask to the surface using the alpha vaules of the masking pattern" do
      mask =
        RadialGradient.new(Point.new(50, 50), 1, Point.new(50, 50), 75)
        |> RadialGradient.add_color_stop(0, Rgba.new(0, 0, 0, 1))
        |> RadialGradient.add_color_stop(1, Rgba.new(0, 0, 0, 0))

      Image.new("mask_radial.png", 100, 100)
      |> set_source(Rgba.new(0.5, 0, 1))
      |> mask(mask)
      |> assert_image()
    end

    test "works with a linear gradient" do
      mask =
        LinearGradient.new(Point.new(0, 0), Point.new(100, 100))
        |> LinearGradient.add_color_stop(0, Rgba.new(0, 0, 0, 1))
        |> LinearGradient.add_color_stop(1, Rgba.new(0, 0, 0, 0))

      Image.new("mask_linear.png", 100, 100)
      |> set_source(Rgba.new(0.5, 0, 1))
      |> mask(mask)
      |> assert_image()
    end

    test "works with a mesh" do
      mesh =
        Mesh.new()
        |> Mesh.begin_patch()
        |> Mesh.move_to(Point.new(10, 10))
        |> Mesh.curve_to(Point.new(20, 20), Point.new(50, -10), Point.new(130, -30))
        |> Mesh.curve_to(Point.new(80, 20), Point.new(90, 30), Point.new(100, 100))
        |> Mesh.curve_to(Point.new(20, 100), Point.new(10, 130), Point.new(-10, 80))
        |> Mesh.curve_to(Point.new(0, 70), Point.new(10, 50), Point.new(-10, -10))
        |> Mesh.set_corner_color(0, Rgba.new(1, 0, 0, 1))
        |> Mesh.set_corner_color(1, Rgba.new(1, 0.5, 0, 0.2))
        |> Mesh.set_corner_color(2, Rgba.new(1, 1, 0, 0.5))
        |> Mesh.set_corner_color(3, Rgba.new(0.5, 1, 0, 0.1))
        |> Mesh.end_patch()

      Image.new("mask_mesh.png", 100, 100)
      |> set_source(Rgba.new(0.5, 0, 1))
      |> mask(mesh)
      |> assert_image()
    end

    test "works with a solid pattern" do
      pattern = SolidPattern.from_rgba(Rgba.new(1, 1, 1, 0.3))

      Image.new("mask_solid.png", 100, 100)
      |> set_source(Rgba.new(0.5, 0, 1))
      |> mask(pattern)
      |> assert_image()
    end

    test "works with a surface pattern" do
      pattern_image =
        Image.new("pattern.png", 100, 100)
        |> set_source(Rgba.new(0, 0, 0))
        |> move_to(Point.new(10, 10))
        |> line_to(Point.new(80, 70))
        |> stroke()
        |> set_source(Rgba.new(0, 0, 0, 0.4))
        |> rectangle(Point.new(20, 20), 30, 40)
        |> fill()

      pattern = SurfacePattern.create(pattern_image.surface)

      Image.new("mask_surface_pattern.png", 100, 100)
      |> set_source(Rgba.new(0.5, 0, 1))
      |> mask(pattern)
      |> assert_image()
    end
  end

  describe "mask_surface/2" do
    test "applies an alpha mask to the surface using the alpha vaules of the masking surface" do
      mask_image =
        Image.new("mask.png", 100, 100)
        |> set_source(Rgba.new(0, 0, 0))
        |> move_to(Point.new(10, 10))
        |> line_to(Point.new(80, 70))
        |> stroke()
        |> set_source(Rgba.new(0, 0, 0, 0.4))
        |> rectangle(Point.new(20, 30), 40, 50)
        |> fill()

      Image.new("mask_surface.png", 100, 100)
      |> set_source(Rgba.new(0.5, 0, 1))
      |> mask_surface(mask_image, Point.new(10, 20))
      |> assert_image()
    end
  end
end
