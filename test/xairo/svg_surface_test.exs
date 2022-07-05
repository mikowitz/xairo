defmodule Xairo.SvgSurfaceTest do
  use ExUnit.Case, async: true

  alias Xairo.{Image, SvgSurface}

  setup do
    on_exit(fn -> File.rm("svg.svg") end)
  end

  describe "new/3" do
    test "returns an SvgSurface struct" do
      surface = SvgSurface.new(100, 100, "svg.svg")

      assert is_struct(surface, SvgSurface)
    end

    test "creates a new SVG file" do
      SvgSurface.new(100, 100, "svg.svg")

      assert File.exists?("svg.svg")
    end

    test "errors when the path is not available" do
      assert SvgSurface.new(100, 100, "non/extant/path.svg") == {:error, :write_error}
    end
  end

  describe "finish/1" do
    test "finishes the surface and prevents further drawing" do
      image =
        Image.new("svg.svg", 100, 100)
        |> Image.save()

      assert Xairo.stroke(image) == {:error, :surface_finished}
    end
  end

  describe "document_unit/1" do
    test "returns the document unit of the SvgSurface" do
      surface = SvgSurface.new(100, 100, "svg.svg")

      assert SvgSurface.document_unit(surface) == :pt
    end
  end

  describe "set_document_unit/2" do
    test "sets the document unit for the SvgSurface" do
      surface =
        SvgSurface.new(100, 100, "svg.svg")
        |> SvgSurface.set_document_unit(:mm)

      assert SvgSurface.document_unit(surface) == :mm
    end

    test "raises an error when passed an invalid unit" do
      surface = SvgSurface.new(100, 100, "svg.svg")

      assert_raise ErlangError, ~r/:invalid_variant/, fn ->
        SvgSurface.set_document_unit(surface, :my_weird_unit)
      end
    end
  end
end
