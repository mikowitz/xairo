defmodule Xairo.FontExtentsTest do
  use ExUnit.Case, async: true

  alias Xairo.{Context, FontExtents, ImageSurface}

  describe "for/1" do
    @describetag macos: false

    test "returns the font extents for the context's current font settings" do
      surface = ImageSurface.create(:argb32, 100, 100)
      context = Context.new(surface)

      extents = FontExtents.for(context)

      assert is_struct(extents, FontExtents)

      assert_in_delta extents.ascent, 10, 0.0001
      assert_in_delta extents.descent, 3, 0.0001
      assert_in_delta extents.height, 12, 0.0001
      assert_in_delta extents.max_x_advance, 19, 0.0001
      assert_in_delta extents.max_y_advance, 0, 0.0001
    end

    test "takes font transformations into account" do
      surface = ImageSurface.create(:argb32, 100, 100)

      context =
        Context.new(surface)
        |> Context.set_font_size(5)
        |> Context.select_font_face("Times New Roman", :italic, :bold)

      extents = FontExtents.for(context)

      assert_in_delta extents.ascent, 5, 0.0001
      assert_in_delta extents.descent, 2, 0.0001
      assert_in_delta extents.height, 6, 0.0001
      assert_in_delta extents.max_x_advance, 6, 0.0001
      assert_in_delta extents.max_y_advance, 0, 0.0001
    end
  end
end
