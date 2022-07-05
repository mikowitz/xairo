defmodule Xairo.FontExtentsTest do
  use ExUnit.Case, async: true

  alias Xairo.{FontExtents, Image}
  import Xairo

  describe "for/1" do
    @describetag macos: false

    test "returns the font extents for the context's current font settings" do
      extents =
        Image.new("test.png", 100, 100)
        |> FontExtents.for()

      assert is_struct(extents, FontExtents)

      assert_in_delta extents.ascent, 10, 0.0001
      assert_in_delta extents.descent, 3, 0.0001
      assert_in_delta extents.height, 12, 0.0001
      assert_in_delta extents.max_x_advance, 19, 0.0001
      assert_in_delta extents.max_y_advance, 0, 0.0001
    end

    @tag ci_only: true
    test "takes font size into account" do
      extents =
        Image.new("test.png", 100, 100)
        |> set_font_size(5)
        |> select_font_face("Times New Roman", :italic, :bold)
        |> FontExtents.for()

      assert_in_delta extents.ascent, 5, 0.0001
      assert_in_delta extents.descent, 2, 0.0001
      assert_in_delta extents.height, 6, 0.0001
      assert_in_delta extents.max_x_advance, 6, 0.0001
      assert_in_delta extents.max_y_advance, 0, 0.0001
    end

    test "does not take the context's CTM into account" do
      extents =
        Image.new("test.png", 100, 100)
        |> rotate(1.5)
        |> FontExtents.for()

      assert is_struct(extents, FontExtents)

      assert_in_delta extents.ascent, 10, 0.0001
      assert_in_delta extents.descent, 3, 0.0001
      assert_in_delta extents.height, 12, 0.0001
      assert_in_delta extents.max_x_advance, 19, 0.0001
      assert_in_delta extents.max_y_advance, 0, 0.0001
    end
  end
end
