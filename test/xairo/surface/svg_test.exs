defmodule Xairo.Surface.SvgTest do
  use ExUnit.Case, async: true

  alias Xairo.{Surface, Surface.Svg}

  describe "create/3" do
    @tag :tmp_dir
    test "new surface is a reference", %{tmp_dir: tmp_dir} do
      path = Path.join(tmp_dir, "test.svg")
      {:ok, surface} = Svg.create(path, 100, 200)

      assert is_reference(surface)
    end

    @tag :tmp_dir
    test "creates an empty file", %{tmp_dir: tmp_dir} do
      path = Path.join(tmp_dir, "test.svg")
      {:ok, _surface} = Svg.create(path, 100, 200)

      assert File.exists?(path)
      assert File.read!(path) == <<>>
    end

    test "errors if the directory doesn't exist" do
      assert {:error, :write_error} = Svg.create("/does/not/exist.svg", 100, 200)
    end
  end

  describe "create_for_stream/2" do
    test "returns a surface" do
      {:ok, surface} = Svg.create_for_stream(100, 200)

      assert is_reference(surface)
    end
  end

  describe "to_binary/1" do
    @tag :tmp_dir
    test "returns an error on a file-backed SVG image", %{tmp_dir: tmp_dir} do
      path = Path.join(tmp_dir, "test.svg")
      {:ok, surface} = Svg.create(path, 100, 200)

      assert {:error, :not_in_memory} = Svg.to_binary(surface)
    end
  end

  describe "finish/1" do
    @tag :tmp_dir
    test "writes a valid SVG document to disk", %{tmp_dir: tmp_dir} do
      path = Path.join(tmp_dir, "test.svg")
      {:ok, surface} = Svg.create(path, 100, 200)
      Surface.finish(surface)

      assert File.read!(path) =~ ~r/\A<\?xml.*<svg.*width="100".*height="200"/s
    end

    test "populates a svg surface stream" do
      {:ok, surface} = Svg.create_for_stream(100, 200)
      surface = Surface.finish(surface)
      {:ok, data} = Svg.to_binary(surface)

      assert data =~ ~r/\A<\?xml.*<svg.*width="100".*height="200"/s
    end
  end
end
