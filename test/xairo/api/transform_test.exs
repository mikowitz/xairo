defmodule Xairo.Api.TransformTest do
  use ExUnit.Case
  import Xairo.Test.Support.ImageHelpers

  alias Xairo.{Image, Matrix, Point, Rgba}

  import Xairo

  describe "matrix/1" do
    test "returns the context's CTM" do
      image =
        Image.new("test.png", 100, 100)
        |> rotate(:math.pi() / 5)
        |> translate(25, -5)

      matrix = matrix(image)

      {xx, yx, xy, yy, tx, ty} = Matrix.to_tuple(matrix)

      assert_in_delta xx, 0.809, 0.0001
      assert_in_delta yx, 0.5877, 0.0001
      assert_in_delta xy, -0.5877, 0.0001
      assert_in_delta yy, 0.809, 0.0001
      assert_in_delta tx, 23.1643, 0.0001
      assert_in_delta ty, 10.6495, 0.0001
    end
  end

  describe "set_font_matrix/2" do
    @tag macos: false
    test "affects just the font, not other drawing" do
      matrix =
        Matrix.identity()
        |> Matrix.translate(2, 2)
        |> Matrix.scale(25, 50)
        |> Matrix.rotate(:math.pi() / 6)

      Image.new("font_matrix.png", 100, 100)
      |> set_source(Rgba.new(1, 0, 0.5))
      |> set_font_size(25)
      |> move_to(Point.new(0, 0))
      |> line_to(Point.new(20, 20))
      |> show_text("hello")
      |> stroke()
      |> set_source(Rgba.new(0.5, 0, 1))
      |> set_font_matrix(matrix)
      |> move_to(Point.new(0, 0))
      |> line_to(Point.new(20, 20))
      |> show_text("hello")
      |> stroke()
      |> assert_image()
    end
  end

  describe "font_matrix/1" do
    test "returns the font CTM for the context" do
      matrix =
        Matrix.identity()
        |> Matrix.translate(2, 2)
        |> Matrix.scale(25, 50)
        |> Matrix.rotate(:math.pi() / 6)

      image =
        Image.new("test.png", 100, 100)
        |> set_font_matrix(matrix)

      font_matrix = font_matrix(image)

      {xx, yx, xy, yy, tx, ty} = Matrix.to_tuple(font_matrix)

      assert_in_delta xx, 21.6506, 0.0001
      assert_in_delta yx, 25.0, 0.0001
      assert_in_delta xy, -12.5, 0.0001
      assert_in_delta yy, 43.3013, 0.0001
      assert tx == 2.0
      assert ty == 2.0
    end
  end

  describe "translate/3" do
    test "translates the context's CTM" do
      starting_image("matrix_translate.png")
      |> translate(30, 50)
      |> move_to(Point.new(10, 10))
      |> line_to(Point.new(30, 30))
      |> stroke()
      |> assert_image()
    end
  end

  describe "scale/3" do
    test "scales the context's CTM" do
      starting_image("matrix_scale.png")
      |> scale(3, 2)
      |> move_to(Point.new(10, 10))
      |> line_to(Point.new(30, 30))
      |> stroke()
      |> assert_image()
    end
  end

  describe "rotate/3" do
    test "rotates the context's CTM" do
      starting_image("matrix_rotate.png")
      |> rotate(:math.pi() / 5)
      |> move_to(Point.new(10, 10))
      |> line_to(Point.new(30, 30))
      |> stroke()
      |> assert_image()
    end
  end

  describe "identity_matrix/3" do
    test "resets the CTM to the identity matrix" do
      starting_image("matrix_identity.png")
      |> rotate(:math.pi() / 5)
      |> move_to(Point.new(10, 10))
      |> line_to(Point.new(30, 30))
      |> stroke()
      |> identity_matrix()
      |> move_to(Point.new(10, 10))
      |> line_to(Point.new(30, 30))
      |> stroke()
      |> assert_image()
    end
  end

  describe "transform/2" do
    test "applies the given matrix as an operation on top of the CTM" do
      matrix =
        Matrix.identity()
        |> Matrix.translate(25, 3)

      starting_image("matrix_transform.png")
      |> rotate(:math.pi() / 5)
      |> move_to(Point.new(10, 10))
      |> line_to(Point.new(30, 30))
      |> stroke()
      |> transform(matrix)
      |> move_to(Point.new(10, 10))
      |> line_to(Point.new(30, 30))
      |> stroke()
      |> assert_image()
    end
  end

  describe "set_matrix/2" do
    test "replaces the context's CTM" do
      matrix =
        Matrix.identity()
        |> Matrix.translate(25, -5)

      starting_image("matrix_set_matrix.png")
      |> rotate(:math.pi() / 5)
      |> move_to(Point.new(10, 10))
      |> line_to(Point.new(30, 30))
      |> stroke()
      |> set_matrix(matrix)
      |> move_to(Point.new(10, 10))
      |> line_to(Point.new(30, 30))
      |> stroke()
      |> assert_image()
    end
  end

  defp starting_image(filename) do
    Image.new(filename, 100, 100)
    |> set_source(Rgba.new(0, 0, 0))
    |> move_to(Point.new(10, 10))
    |> line_to(Point.new(30, 30))
    |> stroke()
    |> set_source(Rgba.new(1, 0, 0))
  end
end
