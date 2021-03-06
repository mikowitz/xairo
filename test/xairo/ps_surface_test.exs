defmodule Xairo.PsSurfaceTest do
  use ExUnit.Case, async: true

  alias Xairo.{Image, PsSurface}

  setup do
    on_exit(fn -> File.rm("ps.ps") end)
  end

  describe "new/3" do
    test "returns a PsSurface struct" do
      surface = PsSurface.new(100, 100, "ps.ps")

      assert is_struct(surface, PsSurface)
    end

    test "creates a new PS file" do
      PsSurface.new(100, 100, "ps.ps")

      assert File.exists?("ps.ps")
    end

    test "errors when the path is not available" do
      assert PsSurface.new(100, 100, "non/extant/path.ps") == {:error, :write_error}
    end
  end

  describe "finish/1" do
    test "finishes the surface and prevents further drawing" do
      image =
        Image.new("ps.ps", 100, 100)
        |> Image.save()

      assert Xairo.stroke(image) == {:error, :surface_finished}
    end
  end
end
