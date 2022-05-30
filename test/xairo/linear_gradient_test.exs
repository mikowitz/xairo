defmodule Xairo.LinearGradientTest do
  use ExUnit.Case, async: true

  alias Xairo.LinearGradient

  describe "new/4" do
    test "returns a LinearGradient struct" do
      gradient = LinearGradient.new(10, 10, 75, 80)

      assert is_struct(gradient, LinearGradient)
    end
  end

  describe "linear_points/1" do
    test "returns the bounding points for the gradient" do
      gradient = LinearGradient.new(10, 10, 75, 80)

      assert LinearGradient.linear_points(gradient) == {10.0, 10.0, 75.0, 80.0}
    end
  end

  describe "add_color_stop_rgb" do
    test "sets a color stop at the given offset with the given RGB color" do
      gradient =
        LinearGradient.new(10, 10, 75, 80)
        |> LinearGradient.add_color_stop_rgb(0.8, 0.5, 0, 1)
        |> LinearGradient.add_color_stop_rgb(0.2, 1, 0, 0)

      assert LinearGradient.color_stop_count(gradient) == 2

      assert LinearGradient.color_stop_rgba(gradient, 0) == {0.2, 1.0, 0.0, 0.0, 1.0}
      assert LinearGradient.color_stop_rgba(gradient, 1) == {0.8, 0.5, 0.0, 1.0, 1.0}
    end
  end

  describe "add_color_stop_rgba" do
    gradient =
      LinearGradient.new(10, 10, 75, 80)
      |> LinearGradient.add_color_stop_rgba(0.5, 0.5, 0, 1, 0.3)

    assert LinearGradient.color_stop_count(gradient) == 1

    assert LinearGradient.color_stop_rgba(gradient, 0) == {0.5, 0.5, 0.0, 1.0, 0.3}
    assert LinearGradient.color_stop_rgba(gradient, 1) == {:error, :invalid_index}
  end
end
