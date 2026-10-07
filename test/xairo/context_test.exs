defmodule Xairo.ContextTest do
  use ExUnit.Case, async: true

  alias Xairo.{Context, Surface.Image}

  describe "create/1" do
    test "returns an ok tuple on success" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)
      assert is_reference(ctx)
    end
  end

  describe "get_target/1" do
    test "returns an ok tuple with the target surface" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert {:ok, ^surface} = Context.get_target(ctx)
    end
  end

  describe "errors" do
    test "are sticky, and persist once an error state is reached" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, ctx} = Context.create(surface)

      assert {:error, :invalid_restore} = Xairo.restore(ctx)
      assert {:error, :invalid_restore} = Xairo.paint(ctx)
    end
  end
end
