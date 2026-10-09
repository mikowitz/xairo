defmodule XairoTest do
  alias Xairo.{Context, Surface.Image}

  use ExUnit.Case, async: true

  describe "set_source_rgb/4" do
    test "returns the ctx when successful" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.set_source_rgb(ctx, 0.5, 1, 0.3) == ctx
    end
  end

  describe "set_source_rgba/5" do
    test "returns the ctx when successful" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.set_source_rgba(ctx, 0.5, 1, 0.3, 0.8) == ctx
    end
  end

  describe "translate/3" do
    test "returns the ctx" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.translate(ctx, 50.5, 50) == ctx
    end
  end

  describe "rotate/2" do
    test "returns the ctx" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.rotate(ctx, :math.pi() / 4) == ctx
    end

    test "casts integer to float" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.rotate(ctx, 4) == ctx
    end
  end

  describe "rectangle/5" do
    test "returns the context" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.rectangle(ctx, 10.0, 5.3, 200.5, 150.5) == ctx
    end

    test "casts integers to floats" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.rectangle(ctx, 10, 5, 200, 150) == ctx
    end
  end

  describe "arc/6" do
    test "returns the context" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.arc(ctx, 50.0, 50, 20, 0, :math.pi() / 2) == ctx
    end
  end

  describe "curve_to/7" do
    test "returns the context" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.curve_to(ctx, 50.0, 50, 20, 0, 0, 3)
    end
  end

  describe "paint/1" do
    test "returns the ctx when successful" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.paint(ctx) == ctx
    end
  end

  describe "fill/1" do
    test "returns the ctx when successful" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.fill(ctx) == ctx
    end
  end

  describe "fill_preserve/1" do
    test "returns the ctx when successful" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.fill_preserve(ctx) == ctx
    end
  end

  describe "stroke/1" do
    test "returns the ctx when successful" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.stroke(ctx) == ctx
    end
  end

  describe "save/1" do
    test "returns the ctx" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.save(ctx) == ctx
    end
  end

  describe "restore/1" do
    test "returns the ctx on succes" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      ctx = Xairo.save(ctx)
      assert Xairo.restore(ctx) == ctx
    end

    test "returns an error if there is no saved state to restore" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert {:error, :invalid_restore} = Xairo.restore(ctx)
    end
  end

  describe "clip/1" do
    test "returns the ctx" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.clip(ctx) == ctx
    end
  end

  describe "reset_clip/1" do
    test "returns the ctx on succes" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      ctx = Xairo.clip(ctx)
      assert Xairo.reset_clip(ctx) == ctx
    end

    test "reset clip is a no-op if there is no clip" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.reset_clip(ctx) == ctx
    end
  end

  describe "select_font_face/4" do
    test "returns the ctx on success" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.select_font_face(ctx, "sans-serif", :italic, :bold) == ctx
    end

    test "allows invalid family string" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.select_font_face(ctx, "sans-seriff", :normal, :normal) == ctx
    end

    test "returns an error if the slant is invalid" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert_raise FunctionClauseError, fn ->
        apply(Xairo, :select_font_face, [ctx, "sans-serif", :normale, :normal])
      end
    end

    test "returns an error if the weight is invalid" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert_raise FunctionClauseError, fn ->
        apply(Xairo, :select_font_face, [ctx, "sans-serif", :normal, :normale])
      end
    end
  end

  describe "set_font_size/2" do
    test "returns the ctx on success" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.set_font_size(ctx, 20) == ctx
    end
  end

  describe "show_text/2" do
    test "returns the ctx on success" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.show_text(ctx, "hello!") == ctx
    end
  end
end
