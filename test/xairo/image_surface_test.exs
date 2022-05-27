defmodule Xairo.ImageSurfaceTest do
  use ExUnit.Case, async: true
  import Xairo.Test.Support.ImageHelpers

  alias Xairo.ImageSurface

  describe "create/3" do
    test "returns an ImageSurface struct when successful" do
      surface = ImageSurface.create(:argb32, 100, 100)

      assert is_struct(surface, ImageSurface)
    end

    test "raises an error when an invalid format is passed" do
      assert_raise ErlangError, ~r/:invalid_variant/, fn ->
        ImageSurface.create(:rgb32, 100, 100)
      end
    end

    test "returns an error when the image size is too big" do
      assert ImageSurface.create(:argb32, 1_000_000, 1_000_000) == {:error, :invalid_size}
    end
  end

  describe "write_to_png/2" do
    test "writes the ImageSurface to disk when given a valid filename" do
      surface = ImageSurface.create(:argb32, 100, 100)

      assert_image(surface, "image_surface.png")
    end

    test "returns an error when the location is invalid" do
      surface = ImageSurface.create(:argb32, 100, 100)

      assert ImageSurface.write_to_png(surface, "non/extant/path.png") == {:error, :write_error}
    end
  end

  describe "width/1" do
    test "returns the width of the ImageSurface" do
      surface = ImageSurface.create(:argb32, 100, 100)

      assert ImageSurface.width(surface) == 100
    end
  end

  describe "height/1" do
    test "returns the height of the ImageSurface" do
      surface = ImageSurface.create(:argb32, 100, 100)

      assert ImageSurface.height(surface) == 100
    end
  end

  describe "stride/1" do
    test "returns the stride of the ImageSurface" do
      surface = ImageSurface.create(:argb32, 100, 100)

      assert ImageSurface.stride(surface) == 400
    end

    test "returns the correct stride when the byte size of pixel data is not 4" do
      assert ImageSurface.create(:a8, 100, 100) |> ImageSurface.stride() == 100
      assert ImageSurface.create(:a1, 100, 100) |> ImageSurface.stride() == 16
      assert ImageSurface.create(:rgb16_565, 100, 100) |> ImageSurface.stride() == 200
    end
  end

  describe "format/1" do
    test "returns the format of the ImageSurface" do
      surface = ImageSurface.create(:argb32, 100, 100)

      assert ImageSurface.format(surface) == :argb32
    end
  end
end
