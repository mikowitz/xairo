defmodule Xairo.ContextClipTest do
  use ExUnit.Case, async: true

  import Xairo.Test.Support.ImageHelpers

  alias Xairo.{Context, ImageSurface, Point, Rgba}

  import Context

  describe "clip/1" do
    test "clips the inkable surface to the `fill` region of the current path" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      context
      |> rectangle(Point.new(20, 20), 60, 70)
      |> clip_preserve()
      |> set_source(Rgba.new(0, 0, 0))
      |> stroke()
      |> move_to(Point.new(10, 10))
      |> line_to(Point.new(90, 90))
      |> stroke()
      |> rectangle(Point.new(50, 0), 30, 30)
      |> clip()
      |> set_source(Rgba.new(0.5, 0, 0))
      |> stroke()
      |> move_to(Point.new(30, 0))
      |> line_to(Point.new(100, 70))
      |> stroke()
      |> reset_clip()
      |> set_source(Rgba.new(0, 0, 0.8))
      |> move_to(Point.new(0, 30))
      |> line_to(Point.new(70, 100))
      |> stroke()

      assert_image(surface, "clip.png")
    end
  end

  describe "in_clip/3" do
    test "returns true if a point is within the inkable clipped region" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      assert in_clip(context, Point.new(0, 0))
      assert in_clip(context, Point.new(50, 50))
      assert in_clip(context, Point.new(75, 25))

      context =
        context
        |> rectangle(Point.new(20, 20), 60, 70)
        |> clip()

      refute in_clip(context, Point.new(0, 0))
      assert in_clip(context, Point.new(50, 50))
      assert in_clip(context, Point.new(75, 25))

      context =
        context
        |> rectangle(Point.new(50, 0), 30, 30)
        |> clip()

      refute in_clip(context, Point.new(0, 0))
      refute in_clip(context, Point.new(50, 50))
      assert in_clip(context, Point.new(75, 25))

      context = reset_clip(context)

      assert in_clip(context, Point.new(0, 0))
      assert in_clip(context, Point.new(50, 50))
      assert in_clip(context, Point.new(75, 25))
    end
  end

  describe "clip_extents" do
    test "returns the bounding box for the current clip area" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      assert clip_extents(context) == {Point.new(0, 0), Point.new(100, 100)}

      context =
        context
        |> rectangle(Point.new(20, 20), 60, 70)
        |> clip()

      assert clip_extents(context) == {Point.new(20, 20), Point.new(80, 90)}

      context =
        context
        |> rectangle(Point.new(50, 0), 30, 30)
        |> clip()

      assert clip_extents(context) == {Point.new(50, 20), Point.new(80, 30)}

      context = reset_clip(context)

      assert clip_extents(context) == {Point.new(0, 0), Point.new(100, 100)}
    end
  end

  describe "clip_rectangle_list" do
    test "returns a list of rectangles that define the current clip region" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      assert clip_rectangle_list(context) == [
               {Point.new(0.0, 0.0), 100.0, 100.0}
             ]

      context =
        context
        |> rectangle(Point.new(20, 20), 60, 70)
        |> clip()

      assert clip_rectangle_list(context) == [
               {Point.new(20.0, 20.0), 60.0, 70.0}
             ]
    end

    test "returns an error if the clip region cannot be represented by rectangles" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      context
      |> arc(Point.new(50, 50), 25, 0, :math.pi() * 2)
      |> clip()

      assert clip_extents(context) == {Point.new(25, 25), Point.new(75, 75)}

      assert clip_rectangle_list(context) == {:error, :clip_not_representable}
    end
  end
end
