defmodule Xairo.SolidPatternTest do
  use ExUnit.Case, async: true

  alias Xairo.{Rgba, SolidPattern}

  describe "from_rgba/1" do
    test "returns a SolidPattern from the Rgba struct values" do
      pattern = SolidPattern.from_rgba(Rgba.new(1, 1, 0.2, 0.3))

      assert is_struct(pattern, SolidPattern)

      assert SolidPattern.rgba(pattern) == %Rgba{
               red: 1.0,
               green: 1.0,
               blue: 0.2,
               alpha: 0.3
             }
    end
  end
end
