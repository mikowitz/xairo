defmodule Xairo.TransformationsTest do
  use ExUnit.Case, async: true

  alias Xairo.{Context, Matrix, Surface.Image}

  setup do
    {:ok, surface} = Image.create(:argb32, 100, 100)
    {:ok, ctx} = Context.create(surface)
    %{ctx: ctx}
  end

  describe "translate/3" do
    test "returns the context", %{ctx: ctx} do
      assert Xairo.translate(ctx, 3, 4) == ctx
    end

    test "updates the context's CTM", %{ctx: ctx} do
      assert ctx |> Xairo.translate(3, 4) |> Xairo.get_matrix() == Matrix.init_translate(3, 4)
    end
  end

  describe "scale/3" do
    test "returns the context", %{ctx: ctx} do
      assert Xairo.scale(ctx, 2, 5) == ctx
    end

    test "updates the context's CTM", %{ctx: ctx} do
      assert ctx |> Xairo.scale(2, 5) |> Xairo.get_matrix() ==
               Matrix.init_scale(2, 5)
    end
  end

  describe "rotate/3" do
    test "returns the context", %{ctx: ctx} do
      assert Xairo.rotate(ctx, :math.pi() / 2) == ctx
    end

    test "updates the context's CTM", %{ctx: ctx} do
      assert ctx |> Xairo.rotate(:math.pi() / 2) |> Xairo.get_matrix() ==
               Matrix.init_rotate(:math.pi() / 2)
    end
  end

  describe "transform/2" do
    test "returns the context", %{ctx: ctx} do
      assert Xairo.transform(ctx, Matrix.init(1, 2, 3, 4, 5, 6))
             |> Xairo.transform(Matrix.init(1 / 2, 1 / 3, 1 / 4, 1 / 5, 1 / 6, 1 / 7)) == ctx
    end

    test "updates the context's CTM", %{ctx: ctx} do
      ctm =
        Xairo.transform(ctx, Matrix.init(1, 2, 3, 4, 5, 6))
        |> Xairo.transform(Matrix.init(1 / 2, 1 / 3, 1 / 4, 1 / 5, 1 / 6, 1 / 7))
        |> Xairo.get_matrix()

      assert_matrices_equal(
        ctm,
        Matrix.init(
          1.5,
          2.3333333333,
          0.85,
          1.3,
          5.5952380952,
          6.9047619048
        )
      )
    end
  end

  describe "set_matrix/2" do
    test "returns the context", %{ctx: ctx} do
      matrix = Matrix.init(1, 2, 3, 4, 5, 6)

      assert Xairo.set_matrix(ctx, matrix) == ctx
    end

    test "sets the ctm", %{ctx: ctx} do
      matrix = Matrix.init(1, 2, 3, 4, 5, 6)

      ctx = Xairo.set_matrix(ctx, matrix)

      assert_matrices_equal(
        Xairo.get_matrix(ctx),
        matrix
      )
    end
  end

  describe "identity_matrix/1" do
    test "returns the context", %{ctx: ctx} do
      assert Xairo.identity_matrix(ctx) == ctx
    end

    test "resets the ctm to the identity matrix", %{ctx: ctx} do
      matrix = Matrix.init(1, 2, 3, 4, 5, 6)

      ctx = Xairo.set_matrix(ctx, matrix)

      refute Xairo.get_matrix(ctx) == Matrix.init_identity()

      ctx = Xairo.identity_matrix(ctx)

      assert_matrices_equal(
        Xairo.get_matrix(ctx),
        Matrix.init_identity()
      )
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
