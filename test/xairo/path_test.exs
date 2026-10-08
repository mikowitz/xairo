defmodule Xairo.PathTest do
  alias Xairo.Context
  alias Xairo.Surface.Image
  use ExUnit.Case, async: true

  describe "new_path/1" do
    test "returns the context" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.new_path(ctx) == ctx
    end

    test "clears the current point" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      ctx = Xairo.move_to(ctx, 10, 10) |> Xairo.new_path()

      refute Xairo.has_current_point(ctx)
    end
  end

  describe "new_sub_path/1" do
    test "returns the context" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.new_sub_path(ctx) == ctx
    end

    test "clears the current point" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      ctx = Xairo.move_to(ctx, 10, 10) |> Xairo.new_sub_path()

      refute Xairo.has_current_point(ctx)
    end
  end

  describe "close_path/1" do
    test "returns the context" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.close_path(ctx) == ctx
    end

    test "returns to the beginning of the path" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      ctx = Xairo.move_to(ctx, 2, 2) |> Xairo.line_to(10, 10) |> Xairo.close_path()

      assert Xairo.has_current_point(ctx)
      assert Xairo.get_current_point(ctx) == {2.0, 2.0}
    end
  end

  describe "move_to/3" do
    test "returns the ctx" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.move_to(ctx, 1.5, 3.7) == ctx
    end

    test "casts integers to floats" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.move_to(ctx, 1, 3) == ctx
    end
  end

  describe "rel_move_to/3" do
    test "returns the ctx" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.move_to(ctx, 5, 5) |> Xairo.rel_move_to(1.5, 3.7) == ctx
      {x, y} = Xairo.get_current_point(ctx)
      assert_in_delta x, 6.5, 0.001
      assert_in_delta y, 8.7, 0.001
    end

    test "returns an error if there is no current point" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert {:error, :no_current_point} = Xairo.rel_move_to(ctx, 1.5, 3.7)
    end
  end

  describe "line_to/3" do
    test "returns the ctx" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.line_to(ctx, 10, 3.7) == ctx
      {x, y} = Xairo.get_current_point(ctx)
      assert_in_delta x, 10.0, 0.001
      assert_in_delta y, 3.7, 0.001
    end
  end

  describe "rel_line_to/3" do
    test "returns the ctx" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.line_to(ctx, 5, 5) |> Xairo.rel_line_to(1.5, 3.7) == ctx
      {x, y} = Xairo.get_current_point(ctx)
      assert_in_delta x, 6.5, 0.001
      assert_in_delta y, 8.7, 0.001
    end

    test "returns an error if there is no current point" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert {:error, :no_current_point} = Xairo.rel_line_to(ctx, 1.5, 3.7)
    end
  end

  describe "arc/6" do
    test "returns the context" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.arc(ctx, 50.0, 50, 20, 0, :math.pi() / 2) == ctx
      assert Xairo.has_current_point(ctx)
    end
  end

  describe "arc_negative/6" do
    test "returns the context" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.arc_negative(ctx, 50.0, 50, 20, 0, :math.pi() / 2) == ctx
      assert Xairo.has_current_point(ctx)
    end
  end

  describe "curve_to/7" do
    test "returns the context" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.curve_to(ctx, 50.0, 50, 20, 0, 0, 3) == ctx
      assert Xairo.has_current_point(ctx)
    end
  end

  describe "rel_curve_to/7" do
    test "returns the context" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.move_to(ctx, 5, 5) |> Xairo.rel_curve_to(50.0, 50, 20, 0, 0, 3)
      assert Xairo.has_current_point(ctx)
    end

    test "returns an error if there is no current point" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert {:error, :no_current_point} = Xairo.rel_curve_to(ctx, 50.0, 50, 20, 0, 0, 3)
    end
  end

  describe "path_extents/1" do
    test "returns an empty rectangle when there is no path" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert Xairo.path_extents(ctx) == {{0.0, 0.0}, {0.0, 0.0}}
    end

    test "returns an non-empty rectangle when there is a path" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      refute ctx
             |> Xairo.move_to(10, 10)
             |> Xairo.line_to(5, 5)
             |> Xairo.arc(3, 3, 2, 0, :math.pi())
             |> Xairo.path_extents() == {{0.0, 0.0}, {0.0, 0.0}}
    end
  end
end
