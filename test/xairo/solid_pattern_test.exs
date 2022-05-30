defmodule Xairo.SolidPatternTest do
  use ExUnit.Case, async: true

  alias Xairo.SolidPattern

  describe "from_rgb/3" do
    test "returns a SolidPattern from RGB values" do
      pattern = SolidPattern.from_rgb(0, 1, 0.5)

      assert is_struct(pattern, SolidPattern)

      assert SolidPattern.rgba(pattern) == {0.0, 1.0, 0.5, 1.0}
    end
  end

  describe "from_rgba/4" do
    test "returns a SolidPattern from RGBA values" do
      pattern = SolidPattern.from_rgba(1, 1, 0.2, 0.3)

      assert is_struct(pattern, SolidPattern)

      assert SolidPattern.rgba(pattern) == {1.0, 1.0, 0.2, 0.3}
    end
  end
end
