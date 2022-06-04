defmodule Xairo.ContextOperatorsTest do
  # See
  # https://cairographics.org/operators/
  # for a full description of and math for each operator

  use ExUnit.Case, async: true

  import Xairo.Test.Support.ImageHelpers

  alias Xairo.{Context, ImageSurface}

  setup do
    surface = ImageSurface.create(:argb32, 100, 100)

    context =
      Context.new(surface)
      |> Context.set_source_rgba(0.7, 0, 0, 0.8)
      |> Context.rectangle(0, 0, 60, 45)
      |> Context.fill()

    {:ok, surface: surface, context: context}
  end

  describe ":clear" do
    test "removes anywhere the second object overlaps the first", state do
      test_operator(state.context, state.surface, :clear)
    end
  end

  describe ":source" do
    test "ignores anything under the second object", state do
      test_operator(state.context, state.surface, :source)
    end
  end

  describe ":over" do
    test "applies the color and transparency of both objects (default option)", state do
      test_operator(state.context, state.surface, :over)
    end
  end

  describe ":in" do
    test "removes first object, only draws second object where they overlap", state do
      test_operator(state.context, state.surface, :in)
    end
  end

  describe ":out" do
    test "draws second object only, partially obscured by the first object's transparency, but the first is not drawn at all",
         state do
      test_operator(state.context, state.surface, :out)
    end
  end

  describe ":atop" do
    test "draws first, and second where it overlaps", state do
      test_operator(state.context, state.surface, :atop)
    end
  end

  describe ":dest" do
    test "draws first, ignores second completely", state do
      test_operator(state.context, state.surface, :dest)
    end
  end

  describe ":dest_over" do
    test "draws both, but draws second below first", state do
      test_operator(state.context, state.surface, :dest_over)
    end
  end

  describe ":dest_in" do
    test "draws the first only where the second overlaps", state do
      test_operator(state.context, state.surface, :dest_in)
    end
  end

  describe ":dest_out" do
    test "draws the first only, partially obscured by the second's transparency where they overlap",
         state do
      test_operator(state.context, state.surface, :dest_out)
    end
  end

  describe ":dest_atop" do
    test "draws second, and first where it overlaps", state do
      test_operator(state.context, state.surface, :dest_atop)
    end
  end

  describe ":xor" do
    test "", state do
      test_operator(state.context, state.surface, :xor)
    end
  end

  describe ":add" do
    test "", state do
      test_operator(state.context, state.surface, :add)
    end
  end

  describe ":saturate" do
    test "", state do
      test_operator(state.context, state.surface, :saturate)
    end
  end

  describe ":multiply" do
    test "result color is at least as dark as the darker input", state do
      test_operator(state.context, state.surface, :multiply)
    end
  end

  describe ":screen" do
    test "result color is at least as light as the lighter input", state do
      test_operator(state.context, state.surface, :screen)
    end
  end

  describe ":overlay" do
    test "multiplies or screens depending on lightness of the first object", state do
      test_operator(state.context, state.surface, :overlay)
    end
  end

  describe ":darken" do
    test "selects the darker of the color values", state do
      test_operator(state.context, state.surface, :darken)
    end
  end

  describe ":lighten" do
    test "selects the lighter of the color values", state do
      test_operator(state.context, state.surface, :lighten)
    end
  end

  describe ":color_dodge" do
    test "brightens the destination by a factor determined by the source", state do
      test_operator(state.context, state.surface, :color_dodge)
    end
  end

  describe ":color_burn" do
    test "darkens the destination by a factor determined by the source", state do
      test_operator(state.context, state.surface, :color_burn)
    end
  end

  describe ":hard_light" do
    test "multiplies or screens depending on the lightness of the source color", state do
      test_operator(state.context, state.surface, :hard_light)
    end
  end

  describe ":soft_light" do
    test "darkens or lightens depending on the source color", state do
      test_operator(state.context, state.surface, :soft_light)
    end
  end

  describe ":difference" do
    test "takes the difference of the destination and source colors", state do
      test_operator(state.context, state.surface, :difference)
    end
  end

  describe ":exclusion" do
    test "a lower-contrast version of :difference", state do
      test_operator(state.context, state.surface, :exclusion)
    end
  end

  describe ":hsl_hue" do
    test "creates a color with the H of the source and SL of the destination", state do
      test_operator(state.context, state.surface, :hsl_hue)
    end
  end

  describe ":hsl_saturation" do
    test "creates a color with the S of the source and HL of the destination", state do
      test_operator(state.context, state.surface, :hsl_saturation)
    end
  end

  describe ":hsl_color" do
    test "creates a color with the HS of the source and the L of the second", state do
      test_operator(state.context, state.surface, :hsl_color)
    end
  end

  describe ":hsl_luminosity" do
    test "creates a color with the L of the source and the HS of the second", state do
      test_operator(state.context, state.surface, :hsl_luminosity)
    end
  end

  describe "operator/1" do
    test "returns the current operator setting for the context", %{context: ctx} do
      assert Context.operator(ctx) == :over
    end
  end

  defp test_operator(context, surface, operator) do
    context
    |> Context.set_operator(operator)
    |> Context.set_source_rgba(0, 0, 0.9, 0.4)
    |> Context.rectangle(25, 15, 60, 45)
    |> Context.fill()

    assert_image(surface, "operator_#{operator}.png")
  end
end
