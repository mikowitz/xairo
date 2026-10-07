defmodule Xairo.GoldenImageTest do
  alias Xairo.Surface
  use ExUnit.Case, async: true

  describe "golden images" do
    test "shapes" do
      {:ok, golden_data} = File.read(Path.join(Xairo.Goldens.golden_path(), "shapes.png"))

      {_ctx, surface} = Xairo.Goldens.shapes()
      {:ok, data} = Surface.to_png_stream(surface)

      assert data == golden_data,
             "Golden image data differs, check images and run `mix xairo.gen.goldens` to regenerate."
    end

    test "transforms" do
      {:ok, golden_data} = File.read(Path.join(Xairo.Goldens.golden_path(), "transforms.png"))

      {_ctx, surface} = Xairo.Goldens.transforms()
      {:ok, data} = Surface.to_png_stream(surface)

      assert data == golden_data,
             "Golden image data differs, check images and run `mix xairo.gen.goldens` to regenerate."
    end
  end
end
