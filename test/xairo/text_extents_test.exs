defmodule Xairo.TextExtentsTest do
  use ExUnit.Case, async: true

  alias Xairo.{Image, TextExtents}

  import Xairo

  describe "for/2" do
    @describetag macos: false

    test "returns the text extents for the given string in the context's current font settings" do
      extents =
        Image.new("test.png", 100, 100)
        |> TextExtents.for("hello")

      assert is_struct(extents, TextExtents)

      assert_in_delta extents.x_bearing, 0, 0.0001
      assert_in_delta extents.y_bearing, -8, 0.0001
      assert_in_delta extents.width, 24, 0.0001
      assert_in_delta extents.height, 8, 0.0001
      assert_in_delta extents.x_advance, 24, 0.0001
      assert_in_delta extents.y_advance, 0.0, 0.0001
      assert extents.text == "hello"
    end

    test "takes font transformations into account" do
      extents =
        Image.new("test.png", 100, 100)
        |> set_font_size(5)
        |> select_font_face("Times New Roman", :italic, :bold)
        |> TextExtents.for("hello")

      assert is_struct(extents, TextExtents)

      assert_in_delta extents.x_bearing, 0, 0.0001
      assert_in_delta extents.y_bearing, -3, 0.0001
      assert_in_delta extents.width, 10, 0.0001
      assert_in_delta extents.height, 3, 0.0001
      assert_in_delta extents.x_advance, 10, 0.0001
      assert_in_delta extents.y_advance, 0, 0.0001
      assert extents.text == "hello"
    end
  end
end
