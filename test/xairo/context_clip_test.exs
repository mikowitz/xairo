defmodule Xairo.ContextClipTest do
  use ExUnit.Case, async: true

  import Xairo.Test.Support.ImageHelpers

  alias Xairo.{Context, ImageSurface, Rgba}

  import Context

  describe "clip/1" do
    test "clips the inkable surface to the `fill` region of the current path" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      context
      |> rectangle(20, 20, 60, 70)
      |> clip_preserve()
      |> set_source(Rgba.new(0, 0, 0))
      |> stroke()
      |> move_to(10, 10)
      |> line_to(90, 90)
      |> stroke()
      |> rectangle(50, 0, 30, 30)
      |> clip()
      |> set_source(Rgba.new(0.5, 0, 0))
      |> stroke()
      |> move_to(30, 0)
      |> line_to(100, 70)
      |> stroke()
      |> reset_clip()
      |> set_source(Rgba.new(0, 0, 0.8))
      |> move_to(0, 30)
      |> line_to(70, 100)
      |> stroke()

      assert_image(surface, "clip.png")
    end
  end

  describe "in_clip/3" do
    test "returns true if a point is within the inkable clipped region" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      assert in_clip(context, 0, 0)
      assert in_clip(context, 50, 50)
      assert in_clip(context, 75, 25)

      context =
        context
        |> rectangle(20, 20, 60, 70)
        |> clip()

      refute in_clip(context, 0, 0)
      assert in_clip(context, 50, 50)
      assert in_clip(context, 75, 25)

      context =
        context
        |> rectangle(50, 0, 30, 30)
        |> clip()

      refute in_clip(context, 0, 0)
      refute in_clip(context, 50, 50)
      assert in_clip(context, 75, 25)

      context = reset_clip(context)

      assert in_clip(context, 0, 0)
      assert in_clip(context, 50, 50)
      assert in_clip(context, 75, 25)
    end
  end

  describe "clip_extents" do
    test "returns the bounding box for the current clip area" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      assert clip_extents(context) == {0.0, 0.0, 100.0, 100.0}

      context =
        context
        |> rectangle(20, 20, 60, 70)
        |> clip()

      assert clip_extents(context) == {20.0, 20.0, 80.0, 90.0}

      context =
        context
        |> rectangle(50, 0, 30, 30)
        |> clip()

      assert clip_extents(context) == {50.0, 20.0, 80.0, 30.0}

      context = reset_clip(context)

      assert clip_extents(context) == {0.0, 0.0, 100.0, 100.0}
    end
  end

  describe "clip_rectangle_list" do
    test "returns a list of rectangles that define the current clip region" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      assert clip_rectangle_list(context) == [
               {0.0, 0.0, 100.0, 100.0}
             ]

      context =
        context
        |> rectangle(20, 20, 60, 70)
        |> clip()

      assert clip_rectangle_list(context) == [
               {20.0, 20.0, 60.0, 70.0}
             ]
    end

    test "returns an error if the clip region cannot be represented by rectangles" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      context
      |> arc(50, 50, 25, 0, :math.pi() * 2)
      |> clip()

      assert clip_extents(context) == {25.0, 25.0, 75.0, 75.0}

      assert clip_rectangle_list(context) == {:error, :clip_not_representable}
    end
  end
end
