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

  describe "set_source_surface/4" do
    test "returns the ctx when successful" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      {:ok, source} = Image.create(:a8, 50, 50)

      assert Xairo.set_source_surface(ctx, source, 3.5, 4.5) == ctx
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
end
