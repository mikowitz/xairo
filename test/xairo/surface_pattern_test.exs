defmodule Xairo.SurfacePatternTest do
  use ExUnit.Case, async: true

  alias Xairo.{ImageSurface, PdfSurface, PsSurface, SurfacePattern, SvgSurface}

  doctest SurfacePattern

  describe "create/1" do
    test "returns a SurfacePattern struct" do
      surface = ImageSurface.create(:argb32, 100, 100)
      pattern = SurfacePattern.create(surface)

      assert is_struct(pattern, SurfacePattern)
    end

    test "can create from a PdfSurface" do
      surface = PdfSurface.new(100, 100, "surface.pdf")
      pattern = SurfacePattern.create(surface)

      assert is_struct(pattern, SurfacePattern)

      assert SurfacePattern.surface(pattern) == surface

      File.rm("surface.pdf")
    end

    test "can create from a PsSurface" do
      surface = PsSurface.new(100, 100, "surface.ps")
      pattern = SurfacePattern.create(surface)

      assert is_struct(pattern, SurfacePattern)

      assert SurfacePattern.surface(pattern) == surface

      File.rm("surface.ps")
    end

    test "can create from a SvgSurface" do
      surface = SvgSurface.new(100, 100, "surface.svg")
      pattern = SurfacePattern.create(surface)

      assert is_struct(pattern, SurfacePattern)

      assert SurfacePattern.surface(pattern) == surface

      File.rm("surface.svg")
    end
  end

  describe "surface/1" do
    test "returns the assigned surface" do
      surface = ImageSurface.create(:argb32, 100, 100)
      pattern = SurfacePattern.create(surface)

      assert SurfacePattern.surface(pattern) == surface
    end
  end
end
