defmodule Xairo.Surface.ImageTest do
  use ExUnit.Case, async: true

  alias Xairo.Surface.{Image, Svg}

  describe "create/3" do
    test "returns a reference on success" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      assert is_reference(surface)
    end

    test "returns an error tuple when an invalid format is given" do
      assert_raise FunctionClauseError, fn ->
        apply(Image, :create, [:argb, 10, 10])
      end
    end

    test "returns an error tuple when a negative width is given" do
      assert_raise FunctionClauseError, fn -> Image.create(:argb32, -10, 10) end
    end

    test "returns an error tuple when a negative height is given" do
      assert_raise FunctionClauseError, fn -> Image.create(:argb32, 10, -10) end
    end
  end

  describe "create_from_png/1" do
    test "returns a reference on success" do
      {:ok, surface} = Image.create_from_png("test/support/dice.png")
      assert is_reference(surface)
    end

    test "returns an error when the file doesn't exist" do
      assert {:error, :file_not_found} = Image.create_from_png("/does/not/exist.png")
    end

    test "returns an error when the file isn't a PNG image" do
      assert {:error, :png_error} = Image.create_from_png("test/support/dice.jpg")
    end
  end

  @formats ~w(argb32 rgb24 a8 a1 rgb16_565 rgb96f rgba128f)a

  describe "get_format/1" do
    test "format persists in a round trip" do
      for format <- @formats do
        {:ok, surface} = Image.create(format, 10, 10)
        assert Image.get_format(surface) == format
      end
    end

    test "returns an error tuple when called on a non-image surface" do
      {:ok, surface} = Svg.create_for_stream(100, 200)

      assert {:error, :surface_type_mismatch} = Image.get_format(surface)
    end
  end

  describe "get_width/1" do
    test "returns the correct width" do
      {:ok, surface} = Image.create(:argb32, 100, 80)
      assert Image.get_width(surface) == 100
    end
  end

  describe "get_height/1" do
    test "returns the correct height" do
      {:ok, surface} = Image.create(:argb32, 100, 80)
      assert Image.get_height(surface) == 80
    end
  end

  describe "get_stride/1" do
    test "returns the correct stride" do
      {:ok, surface} = Image.create(:argb32, 10, 10)
      assert Image.get_stride(surface) == 40

      {:ok, surface} = Image.create(:a1, 10, 10)
      assert Image.get_stride(surface) == 4

      {:ok, surface} = Image.create(:a1, 33, 10)
      assert Image.get_stride(surface) == 8
    end
  end
end
