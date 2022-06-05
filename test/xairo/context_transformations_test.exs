defmodule Xairo.ContextTransformationsTest do
  use ExUnit.Case, async: true

  import Xairo.Test.Support.ImageHelpers

  alias Xairo.{Context, ImageSurface}

  setup do
    surface = ImageSurface.create(:argb32, 100, 100)

    context =
      Context.new(surface)
      |> Context.set_source_rgb(0, 0, 0)
      |> Context.move_to(10, 10)
      |> Context.line_to(30, 30)
      |> Context.stroke()
      |> Context.set_source_rgb(1, 0, 0)

    {:ok, surface: surface, context: context}
  end

  describe "translate/3" do
    test "translates the context's CTM", %{surface: sfc, context: ctx} do
      ctx
      |> Context.translate(30, 50)
      |> Context.move_to(10, 10)
      |> Context.line_to(30, 30)
      |> Context.stroke()

      ImageSurface.write_to_png(sfc, "matrix_translate.png")

      assert_image(sfc, "matrix_translate.png")
    end
  end

  describe "scale/3" do
    test "scales the context's CTM", %{surface: sfc, context: ctx} do
      ctx
      |> Context.scale(3, 2)
      |> Context.move_to(10, 10)
      |> Context.line_to(30, 30)
      |> Context.stroke()

      ImageSurface.write_to_png(sfc, "matrix_scale.png")

      assert_image(sfc, "matrix_scale.png")
    end
  end

  describe "rotate/3" do
    test "rotates the context's CTM", %{surface: sfc, context: ctx} do
      ctx
      |> Context.rotate(:math.pi() / 5)
      |> Context.move_to(10, 10)
      |> Context.line_to(30, 30)
      |> Context.stroke()

      ImageSurface.write_to_png(sfc, "matrix_rotate.png")

      assert_image(sfc, "matrix_rotate.png")
    end
  end

  describe "identity_matrix/3" do
    test "resets the CTM to the identity matrix", %{surface: sfc, context: ctx} do
      ctx
      |> Context.rotate(:math.pi() / 5)
      |> Context.move_to(10, 10)
      |> Context.line_to(30, 30)
      |> Context.stroke()
      |> Context.identity_matrix()
      |> Context.move_to(10, 10)
      |> Context.line_to(30, 30)
      |> Context.stroke()

      ImageSurface.write_to_png(sfc, "matrix_identity.png")

      assert_image(sfc, "matrix_identity.png")
    end
  end

  describe "transform/2" do
    test "applies the given matrix as an operation on top of the CTM", %{
      surface: sfc,
      context: ctx
    } do
      matrix =
        Xairo.Matrix.identity()
        |> Xairo.Matrix.translate(25, 3)

      ctx
      |> Context.rotate(:math.pi() / 5)
      |> Context.move_to(10, 10)
      |> Context.line_to(30, 30)
      |> Context.stroke()
      |> Context.transform(matrix)
      |> Context.move_to(10, 10)
      |> Context.line_to(30, 30)
      |> Context.stroke()

      ImageSurface.write_to_png(sfc, "matrix_transform.png")

      assert_image(sfc, "matrix_transform.png")
    end
  end

  describe "set_matrix/2" do
    test "replaces the context's CTM", %{
      surface: sfc,
      context: ctx
    } do
      matrix =
        Xairo.Matrix.identity()
        |> Xairo.Matrix.translate(25, -5)

      ctx
      |> Context.rotate(:math.pi() / 5)
      |> Context.move_to(10, 10)
      |> Context.line_to(30, 30)
      |> Context.stroke()
      |> Context.set_matrix(matrix)
      |> Context.move_to(10, 10)
      |> Context.line_to(30, 30)
      |> Context.stroke()

      ImageSurface.write_to_png(sfc, "matrix_set_matrix.png")

      assert_image(sfc, "matrix_set_matrix.png")
    end
  end
end
