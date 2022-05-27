defmodule Xairo.ContextTest do
  use ExUnit.Case, async: true
  import Xairo.Test.Support.ImageHelpers

  alias Xairo.{Context, ImageSurface}

  setup do
    surface = ImageSurface.create(:argb32, 100, 100)
    context = Context.new(surface)

    {:ok, surface: surface, context: context}
  end

  describe "new/1" do
    test "returns a Context built from an ImageSurface" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      assert is_struct(context, Context)
    end
  end

  describe "set_source_rgb/4" do
    test "sets the source color to an opaque RGB-defined color", %{surface: sfc, context: ctx} do
      ctx
      |> Context.set_source_rgb(0.5, 0, 1)
      |> Context.paint()

      assert_image(sfc, "set_source_rgb.png")
    end
  end

  describe "set_source_rgba/5" do
    test "sets the source color to an RGBA-defined color", %{surface: sfc, context: ctx} do
      ctx
      |> Context.set_source_rgba(0, 0.5, 1.0, 0.35)
      |> Context.paint()

      assert_image(sfc, "set_source_rgba.png")
    end
  end

  describe "arc/6" do
    test "draws a clockwise arc using the given coordinates", %{surface: sfc, context: ctx} do
      ctx
      |> Context.set_source_rgb(0, 0, 0)
      |> Context.arc(50, 50, 25, 0, 1.5)
      |> Context.stroke()

      assert_image(sfc, "arc.png")
    end
  end

  describe "arc_negative/6" do
    test "draws a counter-clockwise arc using the given coordinates", %{
      surface: sfc,
      context: ctx
    } do
      ctx
      |> Context.set_source_rgb(0, 0, 0)
      |> Context.arc_negative(50, 50, 25, 0, 1.5)
      |> Context.stroke()

      assert_image(sfc, "arc_negative.png")
    end
  end

  describe "(rel_)curve_to/7" do
    test "draws a curve with either absolute or relative coordinates from the origin", %{
      surface: sfc,
      context: ctx
    } do
      ctx
      |> Context.set_source_rgb(0, 0, 1)
      |> Context.curve_to(10, 30, 50, 5, 80, 20)
      |> Context.move_to(10, 50)
      |> Context.rel_curve_to(15, -5, 40, 20, 60, -20)
      |> Context.stroke()

      assert_image(sfc, "curve_to.png")
    end
  end

  describe "(rel_)line_to/3" do
    test "draws lines to absolute or relative coordinates from the origin", %{
      surface: sfc,
      context: ctx
    } do
      ctx
      |> Context.set_source_rgb(1, 1, 0)
      |> Context.move_to(10, 10)
      |> Context.line_to(50, 60)
      |> Context.rel_line_to(-20, -10)
      |> Context.stroke()

      assert_image(sfc, "line_to.png")
    end
  end

  describe "rectangle/5" do
    test "draws a rectangle from the given coordinate and dimensions", %{
      surface: sfc,
      context: ctx
    } do
      ctx
      |> Context.set_source_rgb(0, 1, 1)
      |> Context.paint_with_alpha(0.2)
      |> Context.set_source_rgb(0, 0, 0)
      |> Context.rectangle(10, 10, 60, 40)
      |> Context.stroke_preserve()
      |> Context.set_source_rgba(0, 0, 1, 0.4)
      |> Context.fill()

      assert_image(sfc, "rectangle.png")
    end
  end

  describe "close_path/1" do
    test "connects the current point to the point of the most recent move_to", %{
      surface: sfc,
      context: ctx
    } do
      ctx
      |> Context.set_source_rgb(1, 0, 1)
      |> Context.move_to(10, 10)
      |> Context.line_to(40, 15)
      |> Context.line_to(60, 40)
      |> Context.rel_move_to(-20, -10)
      |> Context.line_to(5, 80)
      |> Context.line_to(20, 90)
      |> Context.close_path()
      |> Context.stroke()

      assert_image(sfc, "close_path.png")
    end
  end
end
