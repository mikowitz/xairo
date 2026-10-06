defmodule Xairo.SurfaceTest do
  use ExUnit.Case, async: true

  alias Xairo.Surface
  alias Xairo.Surface.Image

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
end
