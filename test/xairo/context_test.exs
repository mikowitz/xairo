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
end
