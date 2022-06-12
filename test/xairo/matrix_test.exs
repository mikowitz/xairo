defmodule Xairo.MatrixTest do
  use ExUnit.Case, async: true

  alias Xairo.{Matrix, Point, Vector}

  doctest Matrix

  describe "new/6" do
    test "returns a Matrix struct" do
      matrix = Matrix.new(2, 0, 0, 2, 0, 0)

      assert is_struct(matrix, Matrix)
    end
  end

  describe "identity/1" do
    test "returns the identity matrix" do
      matrix = Matrix.identity()

      assert is_struct(matrix, Matrix)
    end
  end

  describe "transform_distance/3" do
    test "the identity matrix returns the same distance" do
      matrix = Matrix.identity()

      assert Matrix.transform_distance(matrix, Vector.new(3, 4)) == Vector.new(3, 4)
    end

    test "scales the distance by the scaling factors" do
      matrix = Matrix.new(2, 0, 0, 3, 0, 0)

      assert Matrix.transform_distance(matrix, Vector.new(3, 4)) == Vector.new(6, 12)
    end

    test "ignores the translation factors" do
      matrix = Matrix.new(1, 0, 0, 1, 10, 20)

      assert Matrix.transform_distance(matrix, Vector.new(3, 4)) == Vector.new(3, 4)
    end
  end

  describe "transform_point/3" do
    test "the identity matrix returns the same point" do
      matrix = Matrix.identity()

      assert Matrix.transform_point(matrix, Point.new(3, 4)) == Point.new(3, 4)
    end

    test "scales the point by the scaling factors" do
      matrix = Matrix.new(2, 0, 0, 3, 0, 0)

      assert Matrix.transform_point(matrix, Point.new(3, 4)) == Point.new(6, 12)
    end

    test "adjusts the point by the translation factors" do
      matrix = Matrix.new(1, 0, 0, 1, 10, 20)

      assert Matrix.transform_point(matrix, Point.new(3, 4)) == Point.new(13, 24)
    end
  end

  describe "translate/3" do
    test "returns a matrix that's been translated by the given factors" do
      matrix =
        Matrix.identity()
        |> Matrix.translate(20, 13.5)

      assert Matrix.to_tuple(matrix) == {1.0, 0.0, 0.0, 1.0, 20.0, 13.5}
    end
  end

  describe "scale/3" do
    test "returns a matrix that's been scaled by the given factors" do
      matrix =
        Matrix.identity()
        |> Matrix.scale(3, 2)

      assert Matrix.to_tuple(matrix) == {3.0, 0.0, 0.0, 2.0, 0.0, 0.0}
    end
  end

  describe "rotate/2" do
    test "returns a matrix that's been rotated clockwise by the given radians" do
      matrix =
        Matrix.identity()
        |> Matrix.rotate(:math.pi() / 2)

      {xx, yx, xy, yy, tx, ty} = Matrix.to_tuple(matrix)

      assert_in_delta xx, 0, 0.0001
      assert yx == 1.0
      assert xy == -1.0
      assert_in_delta yy, 0, 0.0001
      assert tx == 0.0
      assert ty == 0.0
    end
  end

  describe "invert/1" do
    test "returns an inverted matrix when inversion is possible" do
      matrix =
        Matrix.identity()
        |> Matrix.scale(3, 2)
        |> Matrix.translate(10, 5)
        |> Matrix.invert()

      {xx, yx, xy, yy, tx, ty} = Matrix.to_tuple(matrix)

      assert_in_delta xx, 0.3333, 0.001
      assert yx == 0.0
      assert xy == 0.0
      assert yy == 0.5
      assert tx == -10.0
      assert ty == -5.0
    end

    test "returns an error when the matrix is noninvertible" do
      matrix =
        Matrix.new(0, 0, 0, 0, 0, 0)
        |> Matrix.invert()

      assert matrix == {:error, :invalid_matrix}
    end
  end

  describe "multiply/2" do
    test "multiplies the two transformations in order" do
      m1 =
        Matrix.identity()
        |> Matrix.rotate(:math.pi() / 2)
        |> Matrix.translate(10, 5)

      m2 =
        Matrix.identity()
        |> Matrix.scale(3, 4)

      {xx, yx, xy, yy, tx, ty} = Matrix.multiply(m1, m2) |> Matrix.to_tuple()

      assert_in_delta xx, 0, 0.0001
      assert yx == 4.0
      assert xy == -3.0
      assert_in_delta yy, 0, 0.0001
      assert_in_delta tx, -15.0, 0.0001
      assert ty == 40.0

      {xx, yx, xy, yy, tx, ty} = Matrix.multiply(m2, m1) |> Matrix.to_tuple()

      assert_in_delta xx, 0, 0.0001
      assert yx == 3.0
      assert xy == -4.0
      assert_in_delta yy, 0, 0.0001
      assert_in_delta tx, -5.0, 0.0001
      assert ty == 10.0
    end
  end
end
