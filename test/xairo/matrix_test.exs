defmodule Xairo.MatrixTest do
  use ExUnit.Case, async: true

  alias Xairo.Matrix

  test "default matrix is the identity matrix" do
    assert %Matrix{} == %Matrix{
             xx: 1.0,
             yx: 0.0,
             xy: 0.0,
             yy: 1.0,
             x0: 0.0,
             y0: 0.0
           }
  end

  describe "init/6" do
    test "returns a new matrix with the provided transformation values" do
      assert Matrix.init(1, 2, 3, 4, 5, 6) == %Matrix{
               xx: 1.0,
               yx: 2.0,
               xy: 3.0,
               yy: 4.0,
               x0: 5.0,
               y0: 6.0
             }
    end
  end

  describe "init_identity/0" do
    test "returns an identity matrix" do
      assert Matrix.init_identity() == %Matrix{
               xx: 1.0,
               yx: 0.0,
               xy: 0.0,
               yy: 1.0,
               x0: 0.0,
               y0: 0.0
             }
    end
  end

  describe "init_translate/2" do
    test "returns a matrix with the provided translation" do
      assert Matrix.init_translate(2, 3) == %Matrix{
               xx: 1.0,
               yx: 0.0,
               xy: 0.0,
               yy: 1.0,
               x0: 2.0,
               y0: 3.0
             }
    end
  end

  describe "init_scale/2" do
    test "returns a matrix with the provided scale" do
      assert Matrix.init_scale(2, 3) == %Matrix{
               xx: 2.0,
               yx: 0.0,
               xy: 0.0,
               yy: 3.0,
               x0: 0.0,
               y0: 0.0
             }
    end
  end

  describe "init_rotate/1" do
    test "returns a matrix with the provided rotation (in radians)" do
      assert_matrices_equal(
        Matrix.init_rotate(0),
        Matrix.init(1, 0, 0, 1, 0, 0)
      )

      assert_matrices_equal(
        Matrix.init_rotate(:math.pi() / 4),
        Matrix.init(
          :math.sqrt(2) / 2,
          :math.sqrt(2) / 2,
          -:math.sqrt(2) / 2,
          :math.sqrt(2) / 2,
          0.0,
          0.0
        )
      )

      assert_matrices_equal(
        Matrix.init_rotate(:math.pi() / 2),
        Matrix.init(0, 1, -1, 0, 0, 0)
      )

      assert_matrices_equal(
        Matrix.init_rotate(-:math.pi() / 3),
        Matrix.init(0.5, -:math.sqrt(3) / 2, :math.sqrt(3) / 2, 0.5, 0.0, 0.0)
      )
    end
  end

  describe "translate/3" do
    test "returns a new matrix representing the original matrix translated by the given values" do
      m = Matrix.init(1, 2, 3, 4, 5, 6)

      assert_matrices_equal(
        Matrix.translate(m, 2.5, 7),
        Matrix.init(1, 2, 3, 4, 28.5, 39)
      )
    end
  end

  describe "scale/3" do
    test "returns a matrix scaled by the given values" do
      m = Matrix.init(1, 2, 3, 4, 5, 6)

      assert_matrices_equal(
        Matrix.scale(m, 2.5, 7),
        Matrix.init(
          2.500,
          5.000,
          21.000,
          28.000,
          5.000,
          6.000
        )
      )
    end
  end

  describe "rotate/2" do
    test "returns a matrix scaled by the given angle (in radians)" do
      m = Matrix.init(1, 2, 3, 4, 5, 6)

      assert_matrices_equal(
        Matrix.rotate(m, :math.pi() / 6),
        Matrix.init(
          2.3660254037844384,
          3.7320508075,
          2.098076211353,
          2.464101615137755,
          5,
          6
        )
      )
    end
  end

  describe "invert/1" do
    test "returns the inverse of the matrix when possible" do
      m = Matrix.init(1, 2, 3, 4, 5, 6)

      {:ok, m_inv} = Matrix.invert(m)

      assert_matrices_equal(
        m_inv,
        Matrix.init(
          -2.000,
          1.000,
          1.500,
          -0.500,
          1.000,
          -2.000
        )
      )
    end

    test "returns an error tuple if the matrix is degenerate" do
      m = Matrix.init(0, 0, 3, 4, 5, 6)

      assert {:error, :invalid_matrix} = Matrix.invert(m)
    end
  end

  describe "multiply/2" do
    test "multiplies the given matrices together" do
      m = Matrix.init(1, 2, 3, 4, 5, 6)
      n = Matrix.init(1, 1, 1, 1, 1, 1)

      assert_matrices_equal(
        Matrix.multiply(m, n),
        Matrix.init(
          3.000,
          3.000,
          7.000,
          7.000,
          12.000,
          12.000
        )
      )
    end

    test "multiplication order matters" do
      m = Matrix.init(1, 2, 3, 4, 5, 6)
      n = Matrix.init(1, 1, 1, 1, 1, 1)

      assert_matrices_equal(
        Matrix.multiply(n, m),
        Matrix.init(
          4.000,
          6.000,
          4.000,
          6.000,
          9.000,
          12.000
        )
      )
    end
  end

  describe "transform_point/3" do
    test "transforms the given point by the matrix" do
      m = Matrix.init(1, 2, 3, 4, 5, 6)

      assert Matrix.transform_point(m, 2, 2) == {13.0, 18.0}
    end
  end

  describe "transform_distance/3" do
    test "transforms the given point by the matrix" do
      m = Matrix.init(1, 2, 3, 4, 5, 6)

      assert Matrix.transform_distance(m, 2, 2) == {8.0, 12.0}
    end
  end

  defp assert_matrices_equal(actual, expected, epsilon \\ 0.0000000001) do
    assert_in_delta actual.xx, expected.xx, epsilon
    assert_in_delta actual.yx, expected.yx, epsilon
    assert_in_delta actual.xy, expected.xy, epsilon
    assert_in_delta actual.yy, expected.yy, epsilon
    assert_in_delta actual.x0, expected.x0, epsilon
    assert_in_delta actual.y0, expected.y0, epsilon
  end
end
