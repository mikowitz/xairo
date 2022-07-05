defmodule Xairo.Api.InitTest do
  use ExUnit.Case

  alias Xairo.{
    Image,
    ImageSurface,
    PdfSurface,
    PsSurface,
    SvgSurface
  }

  import Xairo

  describe "target/1" do
    test "returns the correct surface stsruct for a PNG image" do
      image = Image.new("test.png", 100, 100)
      assert is_struct(target(image), ImageSurface)
    end

    test "returns the correct surface stsruct for a PDF image" do
      image = Image.new("pdf.pdf", 100, 100)
      assert is_struct(target(image), PdfSurface)

      File.rm("pdf.pdf")
    end

    test "returns the correct surface stsruct for a PS image" do
      image = Image.new("ps.ps", 100, 100)
      assert is_struct(target(image), PsSurface)

      File.rm("ps.ps")
    end

    test "returns the correct surface stsruct for an SVG image" do
      image = Image.new("svg.svg", 100, 100)
      assert is_struct(target(image), SvgSurface)

      File.rm("svg.svg")
    end
  end
end
