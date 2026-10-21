defmodule Xairo.GoldenImageTest do
  alias Xairo.Surface
  use ExUnit.Case, async: true

  describe "golden images" do
    for image <- ~w(shapes transforms clipping lsystem_tree surface_source hairlines)a do
      test "#{image}" do
        image = unquote(image)

        {:ok, golden_data} =
          File.read(Path.join(Xairo.Goldens.golden_path(), "#{image}.png"))

        {_ctx, surface} = apply(Xairo.Goldens, image, [])
        {:ok, data} = Surface.to_png_stream(surface)

        assert data == golden_data,
               "Golden image data differs for #{image}.png, check images and run `mix xairo.gen.goldens` to regenerate."
      end
    end

    @tag :skip_ci
    test "text" do
      {:ok, golden_data} =
        File.read(Path.join(Xairo.Goldens.golden_path(), "text.png"))

      {_ctx, surface} = apply(Xairo.Goldens, :text, [])
      {:ok, data} = Surface.to_png_stream(surface)

      assert data == golden_data,
             "Golden image data differs for text.png, check images and run `mix xairo.gen.goldens` to regenerate."
    end
  end
end
