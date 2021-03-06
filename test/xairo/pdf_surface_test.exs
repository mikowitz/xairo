defmodule Xairo.PdfSurfaceTest do
  use ExUnit.Case, async: true

  alias Xairo.{Image, PdfSurface}

  setup do
    on_exit(fn -> File.rm("pdf.pdf") end)
  end

  describe "new/3" do
    test "returns a PdfSurface struct" do
      surface = PdfSurface.new(100, 100, "pdf.pdf")

      assert is_struct(surface, PdfSurface)
    end

    test "creates a new PDF file" do
      PdfSurface.new(100, 100, "pdf.pdf")

      assert File.exists?("pdf.pdf")
    end

    test "errors when the path is not available" do
      assert PdfSurface.new(100, 100, "non/extant/path.pdf") == {:error, :write_error}
    end
  end

  describe "finish/1" do
    test "finishes the surface and prevents further drawing" do
      image =
        Image.new("pdf.pdf", 100, 100)
        |> Image.save()

      assert Xairo.stroke(image) == {:error, :surface_finished}
    end
  end
end
