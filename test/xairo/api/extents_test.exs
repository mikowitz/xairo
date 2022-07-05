defmodule Xairo.Api.ExtentsTest do
  use ExUnit.Case, async: true

  alias Xairo.{Image, Point}

  import Xairo

  describe "path_extents/1" do
    test "returns the bounding rectangle of the current path" do
      image =
        Image.new("test.png", 100, 100)
        |> move_to({10, 10})
        |> line_to({50, 80})
        |> line_to({40, 90})

      assert path_extents(image) == {Point.new(10, 10), Point.new(50, 90)}
    end
  end

  describe "fill_extents/1" do
    test "returns the bounding rectangle for the region that would be inked by `fill`" do
      image =
        Image.new("test.png", 100, 100)
        |> move_to({10, 10})
        |> line_to({50, 80})
        |> line_to({40, 90})

      assert fill_extents(image) == {Point.new(10, 10), Point.new(50, 90)}
    end
  end

  describe "stroke_extents/1" do
    test "returns the bounding rectangle for the region that would be inked by `stroke`" do
      image =
        Image.new("test.png", 100, 100)
        |> move_to({10, 10})
        |> line_to({50, 80})
        |> line_to({40, 90})

      {point1, point2} = stroke_extents(image)
      assert_in_delta point1.x, 9.1328, 0.0001
      assert_in_delta point1.y, 9.5039, 0.0001
      assert_in_delta point2.x, 51.2461, 0.0001
      assert_in_delta point2.y, 90.7070, 0.0001
    end

    test "takes line width into account" do
      image =
        Image.new("test.png", 100, 100)
        |> set_line_width(10)
        |> move_to({10, 10})
        |> line_to({50, 80})
        |> line_to({40, 90})

      {point1, point2} = stroke_extents(image)
      assert_in_delta point1.x, 5.6602, 0.0001
      assert_in_delta point1.y, 7.5195, 0.0001
      assert_in_delta point2.x, 56.2344, 0.0001
      assert_in_delta point2.y, 93.5352, 0.0001
    end
  end

  describe "font_extents/1" do
    test "returns a FontExtents struct" do
      image = Image.new("test.png", 100, 100)

      extents = font_extents(image)

      assert is_struct(extents, Xairo.FontExtents)
    end
  end

  describe "text_extents/1" do
    test "returns a TextExtents struct" do
      image = Image.new("test.png", 100, 100)

      extents = text_extents(image, "hello")

      assert is_struct(extents, Xairo.TextExtents)
    end
  end
end
