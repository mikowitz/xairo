defmodule Xairo.ContextOperatorsTest do
  # See
  # https://cairographics.org/operators/
  # for a full description of and math for each operator

  use ExUnit.Case, async: true

  import Xairo.Test.Support.ImageHelpers

  alias Xairo.{Image, Point, Rgba}

  import Xairo

  describe ":clear" do
    test "removes anywhere the second object overlaps the first" do
      test_operator(:clear)
    end
  end

  describe ":source" do
    test "ignores anything under the second object" do
      test_operator(:source)
    end
  end

  describe ":over" do
    test "applies the color and transparency of both objects (default option)" do
      test_operator(:over)
    end
  end

  describe ":in" do
    test "removes first object, only draws second object where they overlap" do
      test_operator(:in)
    end
  end

  describe ":out" do
    test "draws second object only, partially obscured by the first object's transparency, but the first is not drawn at all" do
      test_operator(:out)
    end
  end

  describe ":atop" do
    test "draws first, and second where it overlaps" do
      test_operator(:atop)
    end
  end

  describe ":dest" do
    test "draws first, ignores second completely" do
      test_operator(:dest)
    end
  end

  describe ":dest_over" do
    test "draws both, but draws second below first" do
      test_operator(:dest_over)
    end
  end

  describe ":dest_in" do
    test "draws the first only where the second overlaps" do
      test_operator(:dest_in)
    end
  end

  describe ":dest_out" do
    test "draws the first only, partially obscured by the second's transparency where they overlap" do
      test_operator(:dest_out)
    end
  end

  describe ":dest_atop" do
    test "draws second, and first where it overlaps" do
      test_operator(:dest_atop)
    end
  end

  describe ":xor" do
    test "" do
      test_operator(:xor)
    end
  end

  describe ":add" do
    test "" do
      test_operator(:add)
    end
  end

  describe ":saturate" do
    test "" do
      test_operator(:saturate)
    end
  end

  describe ":multiply" do
    test "result color is at least as dark as the darker input" do
      test_operator(:multiply)
    end
  end

  describe ":screen" do
    test "result color is at least as light as the lighter input" do
      test_operator(:screen)
    end
  end

  describe ":overlay" do
    test "multiplies or screens depending on lightness of the first object" do
      test_operator(:overlay)
    end
  end

  describe ":darken" do
    test "selects the darker of the color values" do
      test_operator(:darken)
    end
  end

  describe ":lighten" do
    test "selects the lighter of the color values" do
      test_operator(:lighten)
    end
  end

  describe ":color_dodge" do
    test "brightens the destination by a factor determined by the source" do
      test_operator(:color_dodge)
    end
  end

  describe ":color_burn" do
    test "darkens the destination by a factor determined by the source" do
      test_operator(:color_burn)
    end
  end

  describe ":hard_light" do
    test "multiplies or screens depending on the lightness of the source color" do
      test_operator(:hard_light)
    end
  end

  describe ":soft_light" do
    test "darkens or lightens depending on the source color" do
      test_operator(:soft_light)
    end
  end

  describe ":difference" do
    test "takes the difference of the destination and source colors" do
      test_operator(:difference)
    end
  end

  describe ":exclusion" do
    test "a lower-contrast version of :difference" do
      test_operator(:exclusion)
    end
  end

  describe ":hsl_hue" do
    test "creates a color with the H of the source and SL of the destination" do
      test_operator(:hsl_hue)
    end
  end

  describe ":hsl_saturation" do
    test "creates a color with the S of the source and HL of the destination" do
      test_operator(:hsl_saturation)
    end
  end

  describe ":hsl_color" do
    test "creates a color with the HS of the source and the L of the second" do
      test_operator(:hsl_color)
    end
  end

  describe ":hsl_luminosity" do
    test "creates a color with the L of the source and the HS of the second" do
      test_operator(:hsl_luminosity)
    end
  end

  describe "operator/1" do
    test "returns the current operator setting for the context" do
      image = Image.new("test.png", 100, 100)

      assert operator(image) == :over
    end
  end

  defp test_operator(operator) do
    Image.new("operator_#{operator}.png", 100, 100)
    |> set_source(Rgba.new(0.7, 0, 0, 0.8))
    |> rectangle(Point.new(0, 0), 60, 45)
    |> fill()
    |> set_operator(operator)
    |> set_source(Rgba.new(0, 0, 0.9, 0.4))
    |> rectangle(Point.new(25, 15), 60, 45)
    |> fill()
    |> assert_image()
  end
end
