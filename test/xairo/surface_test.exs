defmodule Xairo.SurfaceTest do
  use ExUnit.Case, async: true

  alias Xairo.Surface
  alias Xairo.Surface.{Image, Svg}

  describe "write_to_png/2" do
    @tag :tmp_dir
    test "returns :ok on success", %{tmp_dir: tmp_dir} do
      filename = Path.join(tmp_dir, "test.png")
      {:ok, surface} = Image.create(:argb32, 10, 10)

      :ok = Surface.write_to_png(surface, filename)

      assert File.exists?(filename)
    end

    @tag :tmp_dir
    test "writes valid PNG data", %{tmp_dir: tmp_dir} do
      filename = Path.join(tmp_dir, "test.png")
      {:ok, surface} = Image.create(:argb32, 10, 10)
      :ok = Surface.write_to_png(surface, filename)
      {:ok, data} = File.read(filename)

      assert <<137, "PNG", _::binary>> = data
    end

    test "returns an error tuple when trying to write to a non-existent location" do
      {:ok, surface} = Image.create(:argb32, 10, 10)

      assert {:error, :write_error} = Surface.write_to_png(surface, "/does/not/exist/test.png")
    end
  end

  describe "to_png_stream/1" do
    test "returns an ok tuple on success" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      {:ok, data} = Surface.to_png_stream(surface)
      assert <<137, "PNG", _::binary>> = data
    end
  end

  describe "get_type/1" do
    test "returns :image for image surfaces" do
      {:ok, surface} = Image.create(:argb32, 100, 100)
      assert Surface.get_type(surface) == :image
    end

    @tag :tmp_dir
    test "returns :svg for svg file-backed surfaces", %{tmp_dir: tmp_dir} do
      path = Path.join(tmp_dir, "test.svg")
      {:ok, surface} = Svg.create(path, 100, 200)

      assert Surface.get_type(surface) == :svg
    end

    test "returns :svg for svg in-memory surfaces" do
      {:ok, surface} = Svg.create_for_stream(100, 200)

      assert Surface.get_type(surface) == :svg
    end
  end

  describe "flush/1" do
    test "returns the surface" do
      {:ok, surface} = Image.create(:argb32, 100, 100)
      assert Surface.flush(surface) == surface
    end
  end

  describe "finish/1" do
    test "returns the surface" do
      {:ok, surface} = Image.create(:argb32, 100, 100)
      assert Surface.finish(surface) == surface
    end

    test "makes the surface unavailable for output" do
      {:ok, surface} = Image.create(:argb32, 100, 100)
      Surface.finish(surface)
      assert {:error, :surface_finished} = Surface.write_to_png(surface, "uhoh.png")

      refute File.exists?("uhoh.png")
    end

    test "is idempotent" do
      {:ok, surface} = Image.create(:argb32, 100, 100)
      assert Surface.finish(surface) |> Surface.finish() == surface
    end

    @tag :tmp_dir
    test "writes an svg file-backed image to disk", %{tmp_dir: tmp_dir} do
      path = Path.join(tmp_dir, "test.svg")
      {:ok, surface} = Svg.create(path, 100, 200)

      assert Surface.finish(surface) == surface
      assert File.read!(path) =~ ~r/\A<\?xml.*<svg.*width="100".*height="200"/s
    end
  end
end
