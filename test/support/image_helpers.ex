defmodule Xairo.Test.Support.ImageHelpers do
  @moduledoc false

  import ExUnit.Assertions

  def assert_image(image, expected_filename \\ nil)

  def assert_image(%Xairo.Image{} = image, expected_filename) do
    filename = image.filename

    expected_filename = expected_filename || filename

    :ok = Xairo.Image.save(image)

    actual = :crypto.hash(:md5, File.read!(filename))
    expected = :crypto.hash(:md5, File.read!(Path.join("test/images", expected_filename)))

    assert actual == expected

    :ok = File.rm(filename)
  end

  def assert_image(surface, filename) do
    :ok = Xairo.ImageSurface.write_to_png(surface, filename)

    actual = :crypto.hash(:md5, File.read!(filename))
    expected = :crypto.hash(:md5, File.read!(Path.join("test/images", filename)))

    assert actual == expected

    :ok = File.rm(filename)
  end
end
