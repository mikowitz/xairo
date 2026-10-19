defmodule Xairo.ContextTest do
  use ExUnit.Case, async: true

  alias Xairo.Context

  import Xairo.TestHelpers

  setup :with_context

  describe "create/1" do
    test "returns an ok tuple on success", %{ctx: ctx} do
      assert is_reference(ctx)
    end
  end

  describe "get_target/1" do
    test "returns an ok tuple with the target surface", %{ctx: ctx, surface: surface} do
      assert {:ok, ^surface} = Context.get_target(ctx)
    end
  end

  describe "errors" do
    test "are sticky, and persist once an error state is reached", %{ctx: ctx} do
      assert {:error, :invalid_restore} = Xairo.restore(ctx)
      assert {:error, :invalid_restore} = Xairo.paint(ctx)
    end
  end
end
