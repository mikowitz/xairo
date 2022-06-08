defmodule Xairo.ContextSettingsTest do
  use ExUnit.Case, async: true
  import Xairo.Test.Support.ImageHelpers

  alias Xairo.{Context, ImageSurface, Rgba}

  setup do
    surface = ImageSurface.create(:argb32, 100, 100)
    context = Context.new(surface)

    {:ok, surface: surface, context: context}
  end

  describe "line_width/1" do
    test "returns the currently set line_width", %{context: ctx} do
      assert Context.line_width(ctx) == 2.0

      ctx = Context.set_line_width(ctx, 0.1)

      assert Context.line_width(ctx) == 0.1
    end
  end

  describe "set_antialias/2" do
    test "determines the antialiasing option for drawing", %{surface: sfc, context: ctx} do
      draw = fn ctx, radius ->
        ctx
        |> Context.arc_negative(50, 50, radius, 0, 1.5)
        |> Context.stroke()
      end

      ctx
      |> Context.set_source(Rgba.new(0, 0, 0))
      |> draw.(25)
      |> Context.set_antialias(:none)
      |> draw.(20)
      |> Context.set_antialias(:gray)
      |> draw.(30)
      |> Context.set_antialias(:subpixel)
      |> draw.(35)
      |> Context.set_antialias(:fast)
      |> draw.(40)
      |> Context.set_antialias(:good)
      |> draw.(45)
      |> Context.set_antialias(:best)
      |> draw.(50)

      assert_image(sfc, "antialias.png")
    end
  end

  describe "antialias/1" do
    test "returns the context's current antialias setting", %{context: ctx} do
      ctx =
        ctx
        |> Context.set_antialias(:none)

      assert Context.antialias(ctx) == :none

      ctx =
        ctx
        |> Context.set_antialias(:good)

      assert Context.antialias(ctx) == :good
    end
  end

  describe "set_fill_rule/2" do
    test "determines the fill rule for the next drawn portion of the image", %{
      surface: sfc,
      context: ctx
    } do
      ctx
      |> Context.rectangle(10, 10, 50, 20)
      |> Context.new_sub_path()
      |> Context.arc(20, 20, 15, 0, 2 * :math.pi())
      |> Context.set_fill_rule(:even_odd)
      |> Context.set_source(Rgba.new(0, 0.5, 0))
      |> Context.fill_preserve()
      |> Context.set_source(Rgba.new(0, 0, 0))
      |> Context.stroke()
      |> Context.translate(25, 50)
      |> Context.rectangle(10, 10, 50, 20)
      |> Context.new_sub_path()
      |> Context.arc(20, 20, 15, 0, 2 * :math.pi())
      |> Context.set_fill_rule(:winding)
      |> Context.set_source(Rgba.new(0, 0, 1))
      |> Context.fill_preserve()
      |> Context.set_source(Rgba.new(0, 0, 0))
      |> Context.stroke()

      assert_image(sfc, "fill_rule.png")
    end
  end

  describe "fill_rule/1" do
    test "returns the current fill rule for the context", %{context: ctx} do
      assert Context.fill_rule(ctx) == :winding
    end
  end

  describe "set_line_cap/2" do
    test "determines how line ends are displayed", %{surface: sfc, context: ctx} do
      ctx
      |> Context.set_line_width(10)
      |> Context.set_line_cap(:butt)
      |> Context.move_to(10, 10)
      |> Context.line_to(90, 10)
      |> Context.stroke()
      |> Context.translate(0, 30)
      |> Context.set_line_cap(:round)
      |> Context.move_to(10, 10)
      |> Context.line_to(90, 10)
      |> Context.stroke()
      |> Context.translate(0, 30)
      |> Context.set_line_cap(:square)
      |> Context.move_to(10, 10)
      |> Context.line_to(90, 10)
      |> Context.stroke()

      assert_image(sfc, "line_cap.png")
    end
  end

  describe "line_cap/1" do
    test "returns the current setting for the line cap", %{context: ctx} do
      assert Context.line_cap(ctx) == :butt
    end
  end

  describe "set_line_join/2" do
    test "sets the style for line join", %{surface: sfc, context: ctx} do
      ctx
      |> Context.set_line_width(10)
      |> Context.set_line_join(:miter)
      |> Context.rectangle(10, 10, 30, 30)
      |> Context.stroke()
      |> Context.translate(50, 0)
      |> Context.set_line_join(:round)
      |> Context.rectangle(10, 10, 30, 30)
      |> Context.stroke()
      |> Context.translate(0, 50)
      |> Context.set_line_join(:bevel)
      |> Context.rectangle(10, 10, 30, 30)
      |> Context.stroke()
      |> Context.translate(-50, 0)
      |> Context.set_miter_limit(1)
      |> Context.set_line_join(:miter)
      |> Context.rectangle(10, 10, 30, 30)
      |> Context.stroke()

      assert_image(sfc, "line_join.png")
    end
  end

  describe "line_join/1" do
    test "returns the current line join setting for the context", %{context: ctx} do
      assert Context.line_join(ctx) == :miter
    end
  end

  describe "miter_limit/1" do
    test "returns the currently set miter limit", %{context: ctx} do
      assert Context.miter_limit(ctx) == 10.0
    end
  end

  describe "dashes/3" do
    test "sets the dash pattern for the context", %{surface: sfc, context: ctx} do
      ctx
      |> Context.set_source(Rgba.new(0.5, 0, 1))
      |> Context.paint()
      |> Context.set_source(Rgba.new(0, 0, 0))
      |> Context.set_dash([5, 2], 0)
      |> Context.move_to(10, 10)
      |> Context.line_to(90, 90)
      |> Context.line_to(90, 10)
      |> Context.close_path()
      |> Context.stroke()
      |> Context.move_to(10, 90)
      |> Context.line_to(80, 90)
      |> Context.set_dash([5, 2, 3], 1)
      |> Context.stroke()

      assert_image(sfc, "dashes.png")
    end
  end

  describe "dash_count/1" do
    test "returns the number of dash components in the pattern", %{context: ctx} do
      assert Context.dash_count(ctx) == 0

      ctx = Context.set_dash(ctx, [5, 2, 3], 1)

      assert Context.dash_count(ctx) == 3
    end
  end

  describe "dash/1" do
    test "returns the list of dash components and offset", %{context: ctx} do
      assert Context.dash(ctx) == {[], 0.0}

      ctx = Context.set_dash(ctx, [5, 2, 3], 1)

      assert Context.dash(ctx) == {[5.0, 2.0, 3.0], 1.0}
    end
  end

  describe "dash_dashes/1" do
    test "returns just the list of dash components", %{context: ctx} do
      assert Context.dash_dashes(ctx) == []

      ctx = Context.set_dash(ctx, [5, 2, 3], 1)

      assert Context.dash_dashes(ctx) == [5.0, 2.0, 3.0]
    end
  end

  describe "dash_offset/1" do
    test "returns just the dash offset", %{context: ctx} do
      assert Context.dash_offset(ctx) == 0.0

      ctx = Context.set_dash(ctx, [5, 2, 3], 1)

      assert Context.dash_offset(ctx) == 1.0
    end
  end
end
