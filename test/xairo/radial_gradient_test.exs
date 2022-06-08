defmodule Xairo.RadialGradientTest do
  use ExUnit.Case, async: true

  alias Xairo.{RadialGradient, Rgba}

  describe "new/4" do
    test "returns a RadialGradient struct" do
      gradient = RadialGradient.new(10, 10, 20, 75, 80, 30)

      assert is_struct(gradient, RadialGradient)
    end
  end

  describe "radial_circles/1" do
    test "returns the bounding circles for the gradient" do
      gradient = RadialGradient.new(10, 10, 20, 75, 80, 30)

      assert RadialGradient.radial_circles(gradient) == {10.0, 10.0, 20.0, 75.0, 80.0, 30.0}
    end
  end

  describe "add_color_stop" do
    test "sets a color stop at the given offset with the given RGB color" do
      gradient =
        RadialGradient.new(10, 10, 20, 75, 80, 30)
        |> RadialGradient.add_color_stop(0.8, Rgba.new(0.5, 0, 1))
        |> RadialGradient.add_color_stop(0.2, Rgba.new(1, 0, 0, 0.3))

      assert RadialGradient.color_stop_count(gradient) == 2

      assert RadialGradient.color_stop_rgba(gradient, 0) == {0.2, Rgba.new(1.0, 0.0, 0.0, 0.3)}
      assert RadialGradient.color_stop_rgba(gradient, 1) == {0.8, Rgba.new(0.5, 0.0, 1.0, 1.0)}
    end
  end
end
