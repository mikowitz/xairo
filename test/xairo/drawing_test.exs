defmodule Xairo.DrawingTest do
  use ExUnit.Case, async: true

  alias Xairo.{Context, Surface, Surface.Image}

  setup do
    {:ok, surface} = Image.create(:argb32, 100, 80)
    {:ok, ctx} = Context.create(surface)
    ctx = Xairo.rectangle(ctx, 10, 20, 30, 40)
    %{ctx: ctx}
  end

  describe "stroke" do
    test "stroke/1 clears the current path", %{ctx: ctx} do
      assert Xairo.stroke(ctx) == ctx
      refute Xairo.has_current_point(ctx)
    end

    test "stroke_preserve preserves the current path", %{ctx: ctx} do
      assert Xairo.stroke_preserve(ctx) == ctx
      assert Xairo.has_current_point(ctx)
    end
  end

  describe "fill" do
    test "fill/1 clears the current path", %{ctx: ctx} do
      assert Xairo.fill(ctx) == ctx
      refute Xairo.has_current_point(ctx)
    end

    test "fill_preserve preserves the current path", %{ctx: ctx} do
      assert Xairo.fill_preserve(ctx) == ctx
      assert Xairo.has_current_point(ctx)
    end
  end

  describe "paint" do
    test "paint/1 returns context", %{ctx: ctx} do
      assert Xairo.paint(ctx) == ctx
    end

    test "paint_with_alpha/2 returns context", %{ctx: ctx} do
      assert Xairo.paint_with_alpha(ctx, 0.5) == ctx
    end
  end

  describe "extents" do
    test "fill_extents/1 covers the current path", %{ctx: ctx} do
      assert Xairo.fill_extents(ctx) == {{10.0, 20.0}, {40.0, 60.0}}
    end

    test "stroke_extents/1 includes the space for drawing the path", %{ctx: ctx} do
      assert Xairo.stroke_extents(ctx) == {{9.0, 19.0}, {41.0, 61.0}}
    end

    test "in_fill/3 includes the fill area, but not the stroke width", %{ctx: ctx} do
      assert Xairo.in_fill(ctx, 15, 35)
      assert Xairo.in_fill(ctx, 10, 20)
      assert Xairo.in_fill(ctx, 40, 60)
      refute Xairo.in_fill(ctx, 9, 19)
      refute Xairo.in_fill(ctx, 70, 70)
    end

    test "in_stroke/3 includes the stroke extents", %{ctx: ctx} do
      assert Xairo.in_stroke(ctx, 10, 35)
      assert Xairo.in_stroke(ctx, 41, 20)
      assert Xairo.in_stroke(ctx, 10, 20)
      assert Xairo.in_stroke(ctx, 40, 60)
      assert Xairo.in_stroke(ctx, 10, 19)
      refute Xairo.in_stroke(ctx, 70, 70)
    end
  end

  describe "clipping" do
    test "the default clip is the whole surface", %{ctx: ctx} do
      assert Xairo.clip_extents(ctx) == {{0.0, 0.0}, {100.0, 80.0}}
    end

    test "clip/1 restricts drawing to the current path and clears the path", %{ctx: ctx} do
      ctx = Xairo.clip(ctx)

      assert Xairo.clip_extents(ctx) == {{10.0, 20.0}, {40.0, 60.0}}
      refute Xairo.has_current_point(ctx)
    end

    test "in_clip/3 is true for all points if no clip exists", %{ctx: ctx} do
      assert Xairo.in_clip(ctx, 30, 40)
      assert Xairo.in_clip(ctx, 0, 0)
      assert Xairo.in_clip(ctx, 10, 20)
    end

    test "in_clip/3 is false for points outside the current clip", %{ctx: ctx} do
      ctx = Xairo.clip(ctx)

      assert Xairo.in_clip(ctx, 30, 40)
      refute Xairo.in_clip(ctx, 0, 0)
      assert Xairo.in_clip(ctx, 10, 20)
    end

    test "clip_preserve/1 keeps the path", %{ctx: ctx} do
      ctx = ctx |> Xairo.clip_preserve()

      assert Xairo.clip_extents(ctx) == {{10.0, 20.0}, {40.0, 60.0}}
      assert Xairo.has_current_point(ctx)
    end

    test "multiple calls to clip/1 are intersections", %{ctx: ctx} do
      ctx = ctx |> Xairo.clip() |> Xairo.rectangle(5, 5, 20, 20) |> Xairo.clip()

      assert Xairo.clip_extents(ctx) == {{10.0, 20.0}, {25.0, 25.0}}
    end

    test "reset_clip/1 restores the full clip", %{ctx: ctx} do
      ctx = ctx |> Xairo.rectangle(10, 10, 20, 20) |> Xairo.clip() |> Xairo.reset_clip()

      assert Xairo.clip_extents(ctx) == {{0.0, 0.0}, {100.0, 80.0}}
    end
  end

  test "drawing on a finished surface returns a surface_finished error", %{ctx: ctx} do
    {:ok, surface} = ctx |> Context.get_target()
    Surface.finish(surface)
    assert {:error, :surface_finished} = Xairo.paint(ctx)
  end
end
