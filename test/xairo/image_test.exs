defmodule Xairo.ImageTest do
  use ExUnit.Case, async: true

  alias Xairo.{Image, ImageSurface, PdfSurface, PsSurface, SvgSurface}

  describe "new/3" do
    test "given a png filename returns an image with an ImageSurface surface" do
      image = Image.new("test.png", 100, 100)

      assert is_struct(image, Image)

      assert is_struct(image.surface, ImageSurface)
      assert image.context.surface == image.surface

      assert ImageSurface.format(image.surface) == :argb32
    end

    test "given a pdf filename returns an image with a PdfSurface surface" do
      image = Image.new("test.pdf", 100, 100)

      assert is_struct(image, Image)

      assert is_struct(image.surface, PdfSurface)
      assert image.context.surface == image.surface

      :ok = File.rm("test.pdf")
    end

    test "given a ps filename returns an image with a PsSurface surface" do
      image = Image.new("test.ps", 100, 100)

      assert is_struct(image, Image)

      assert is_struct(image.surface, PsSurface)
      assert image.context.surface == image.surface

      :ok = File.rm("test.ps")
    end

    test "given an svg filename returns an image with an SvgSurface surface" do
      image = Image.new("test.svg", 100, 100)

      assert is_struct(image, Image)

      assert is_struct(image.surface, SvgSurface)
      assert image.context.surface == image.surface

      :ok = File.rm("test.svg")
    end

    test "an unsupported file extension returns an error" do
      assert Image.new("test.txt", 100, 100) ==
               {:error, "Xairo.Image.new/4 only supports PDF, PNG, PS, and SVG file formats"}
    end
  end

  describe "new/4" do
    test "can specify a format for a png image" do
      image = Image.new("test.png", 100, 100, format: :a8)

      assert ImageSurface.format(image.surface) == :a8
    end
  end

  describe "save/1" do
    test "saves a png image" do
      Image.new("test_save.png", 100, 100)
      |> Image.save()

      assert File.exists?("test_save.png")

      :ok = File.rm("test_save.png")
    end

    test "saves a pdf image" do
      Image.new("test_save.pdf", 100, 100)
      |> Image.save()

      assert File.exists?("test_save.pdf")

      :ok = File.rm("test_save.pdf")
    end

    test "saves a ps image" do
      Image.new("test_save.ps", 100, 100)
      |> Image.save()

      assert File.exists?("test_save.ps")

      :ok = File.rm("test_save.ps")
    end

    test "saves a svg image" do
      Image.new("test_save.svg", 100, 100)
      |> Image.save()

      assert File.exists?("test_save.svg")

      :ok = File.rm("test_save.svg")
    end
  end
end
