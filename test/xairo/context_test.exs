defmodule Xairo.ContextTest do
  use ExUnit.Case, async: true

  alias Xairo.{Context, ImageSurface}

  describe "new/1" do
    test "returns a Context built from an ImageSurface" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      assert is_struct(context, Context)
    end
  end
end
