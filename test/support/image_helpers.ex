defmodule Xairo.Test.Support.ImageHelpers do
  import ExUnit.Assertions

  def assert_image(surface, filename) do
    :ok = Xairo.ImageSurface.write_to_png(surface, filename)

    actual = :crypto.hash(:md5, File.read!(filename))
    expected = :crypto.hash(:md5, File.read!(Path.join("test/images", filename)))

    assert actual == expected

    :ok = File.rm(filename)
  end
end
