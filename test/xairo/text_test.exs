defmodule Xairo.TextTest do
  use ExUnit.Case, async: true

  alias Xairo.{FontExtents, TextExtents}

  import Xairo.TestHelpers

  setup :with_context

  describe "select_font_face/4" do
    test "returns the ctx on success", %{ctx: ctx} do
      assert Xairo.select_font_face(ctx, "sans-serif", :italic, :bold) == ctx
    end

    test "allows invalid family string", %{ctx: ctx} do
      assert Xairo.select_font_face(ctx, "sans-seriff", :normal, :normal) == ctx
    end

    test "returns an error if the slant is invalid", %{ctx: ctx} do
      assert_raise FunctionClauseError, fn ->
        apply(Xairo, :select_font_face, [ctx, "sans-serif", :normale, :normal])
      end
    end

    test "returns an error if the weight is invalid", %{ctx: ctx} do
      assert_raise FunctionClauseError, fn ->
        apply(Xairo, :select_font_face, [ctx, "sans-serif", :normal, :normale])
      end
    end
  end

  describe "set_font_size/2" do
    test "returns the ctx on success", %{ctx: ctx} do
      assert Xairo.set_font_size(ctx, 20) == ctx
    end
  end

  describe "show_text/2" do
    test "returns the ctx on success", %{ctx: ctx} do
      assert Xairo.show_text(ctx, "hello!") == ctx
    end
  end

  describe "text_path/2" do
    test "returns the ctx on success", %{ctx: ctx} do
      assert Xairo.text_path(ctx, "hello!") == ctx
    end
  end

  describe "text_extents/2" do
    test "returns a TextExtent struct", %{ctx: ctx} do
      assert is_struct(
               Xairo.text_extents(ctx, "hello!"),
               TextExtents
             )
    end
  end

  describe "font_extents/2" do
    test "returns a FontExtents struct", %{ctx: ctx} do
      assert is_struct(
               Xairo.font_extents(ctx),
               FontExtents
             )
    end
  end
end
